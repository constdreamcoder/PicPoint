//
//  DirectMessageViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/16/24.
//

import Foundation
import RxSwift
import RxCocoa

final class DirectMessageViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    let selectedImageDataListRelay = BehaviorRelay<[Data]>(value: [])
    private let roomInfoSubject = BehaviorSubject<ChatRoom?>(value: nil)
    private let chattingListSubject = BehaviorSubject<[ChatRoomMessage]>(value: [])
    private let sectionsRelay = BehaviorRelay<[DirectMessageTableViewSectionDataModel]>(value: [])
    private let chattingTextSubject = PublishSubject<String>()

    struct Input {
        let chattingTextEvent: Observable<String>
        let didBeginEditing: ControlEvent<Void>
        let didEndEditing: ControlEvent<Void>
        let sendButtonTap: ControlEvent<Void>
        let addImagesButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let chattingText: Driver<String>
        let chattingDidBeginEditingTrigger: Driver<Void>
        let chattingDidEndEditingTrigger: Driver<Void>
        let chattingSendingValid: Driver<Bool>
        let clearSendButtonTrigger: Driver<Void>
        let sections: Driver<[DirectMessageTableViewSectionDataModel]>
        let showPHPickerTrigger: Driver<Void>
        let showImageCountIimitAlertTrigger: Driver<Void>
        let selectedImageList: Driver<[Data]>
    }
    
    init(_ room: ChatRoom) {
        Observable.just(room)
            .withUnretained(self)
            .map { owner, room -> (roomId: String, lastChat: LastChatMessage?) in
                SocketIOManager.shared.setupSocketEventListeners(room.roomId)
                
                owner.roomInfoSubject.onNext(room)
                return (room.roomId, room.lastChat)
            }
            .flatMap { value in
                ChatManager.fetchChattingHistory(
                    params: FetchChattingHistoryParams(roomId: value.roomId),
                    query: FetchChattingHistoryQuery(cursor_date: value.lastChat?.createdAt)
//                    query: FetchChattingHistoryQuery(cursor_date: nil)
                )
                .catch { error in
                    print(error.errorCode, error.errorDesc)
                    return Single<ChattingListModel>.never()
                }
            }
            .withLatestFrom(roomInfoSubject) { chattingListModel, room in
                (room: room, chattingListModel: chattingListModel)
            }
            .map { value in
                let chattingList = value.chattingListModel.data
                
                if chattingList.count >= 1 {
                    let newChattingList = chattingList.map { chat in
                        let sender = UserRepository.shared.read().first { $0.userId == chat.sender.userId }
                        return ChatRoomMessage(
                            chatId: chat.chatId,
                            roomId: chat.roomId,
                            content: chat.content,
                            createdAt: chat.createdAt,
                            sender: sender,
                            files: chat.files
                        )
                    }
                    
                    ChatRoomRepository.shared.appendNewRecentChattingList(
                        value.room?.roomId ?? "",
                        chattingList: newChattingList
                    )
                    
                    guard let lastMessage = newChattingList.last else { return "" }
                    
                    let files: [String] = lastMessage.files.map { $0 }
                    
                    let lastChat = LastChatMessage(
                        chatId: lastMessage.chatId,
                        roomId: lastMessage.roomId,
                        content: lastMessage.content,
                        createdAt: lastMessage.createdAt,
                        sender: lastMessage.sender,
                        files: files
                    )
                    
                    ChatRoomRepository.shared.updateLastChat(lastChat, chatRoom: room)
                }
               
                ChatRoomRepository.shared.getLocationOfDefaultRealm()
                
                return room.roomId
            }
            .subscribe(with: self) { owner, roomId in
                let chatRoom = ChatRoomRepository.shared.read().first { $0.roomId == roomId }
                guard let chatRoom = chatRoom else { return }

                let updatedChaRoomMessages: [ChatRoomMessage] = chatRoom.messages.map { $0 }
                
                owner.chattingListSubject.onNext(updatedChaRoomMessages)
                SocketIOManager.shared.establishConnection()
            }
            .disposed(by: disposeBag)
    }
    
    func transform(input: Input) -> Output {
        let chattingSendingValidation = BehaviorRelay<Bool>(value: false)
        let clearSendButtonTrigger = PublishRelay<Void>()
        let showPHPickerTrigger = PublishRelay<Void>()
        let showImageCountIimitAlertTrigger = PublishRelay<Void>()
        let uploadOnlyTextTrigger = PublishSubject<Void>()
        let uploadImagesAndTextTrigger = PublishSubject<Void>()
        
        chattingListSubject
            .subscribe(with: self) { owner, chattingList in
                let sections = [
                    DirectMessageTableViewSectionDataModel(
                        header: "",
                        items: chattingList
                    )
                ]
                owner.sectionsRelay.accept(sections)
            }
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            input.chattingTextEvent,
            selectedImageDataListRelay
        )
        .withUnretained(self) { owner, value in
            (owner: owner, chattingText: value.0, selectedImageDataList: value.1)
        }
        .bind { value in
            if value.chattingText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                && value.selectedImageDataList.count <= 0 {
                chattingSendingValidation.accept(false)
            } else {
                chattingSendingValidation.accept(true)
                value.owner.chattingTextSubject.onNext(value.chattingText)
            }
        }
        .disposed(by: disposeBag)
        
        input.sendButtonTap
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .withLatestFrom(roomInfoSubject)
            .withLatestFrom(selectedImageDataListRelay) { ($0?.roomId ?? "", $1) }
            .withLatestFrom(chattingTextSubject) { value, chattingText in
                let tuple = (files: value.1, roomId: value.0, chattingText: chattingText)
                print("tuple", tuple)
                return tuple
            }
            .bind(with: self) { owner, value in
                if !value.chattingText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    && value.files.count <= 0 {
                    uploadOnlyTextTrigger.onNext(())
                } else if value.chattingText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    && value.files.count >= 1 {
                    uploadImagesAndTextTrigger.onNext(())
                } else {
                    uploadImagesAndTextTrigger.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        uploadOnlyTextTrigger
            .withLatestFrom(roomInfoSubject)
            .withLatestFrom(chattingTextSubject) { room, chattingText in
                (roomId: room?.roomId ?? "", chattingText: chattingText)
            }
            .flatMap { value in
                ChatManager.sendChat(
                    params: SendChatParams(roomId: value.roomId),
                    body: SendChatBody(
                        content: value.chattingText
                    )
                )
                .catch { error in
                    print(error.errorCode, error.errorDesc)
                    return Single<Chat>.never()
                }
            }
            .subscribe(with: self) { owner, newChat in
                print("채팅 업로드 성공!")
                clearSendButtonTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        uploadImagesAndTextTrigger
            .withLatestFrom(roomInfoSubject)
            .withLatestFrom(selectedImageDataListRelay) {
                (roomId: $0?.roomId ?? "", selectedImageDataList: $1)
            }
            .flatMap { value in
                let imageFiles = value.selectedImageDataList.map {
                    ImageFile(
                        imageData: $0,
                        name: "testimage\(Int.random(in: 1000...2000))",
                        mimeType: .png
                    )
                }
                return ChatManager.uploadImages(
                    params: UploadImagesParams(roomId: value.roomId),
                    body: UploadImagesBody(files: imageFiles)
                )
                .catch { error in
                    print(error.errorCode, error.errorDesc)
                    return Single<ImageFileListModel>.never()
                }
            }
            .withLatestFrom(roomInfoSubject) {
                print("이미지 업로드 성공")
                return (files: $0.files, roomId: $1?.roomId ?? "")
            }
            .withLatestFrom(chattingTextSubject) { value, chattingText in
                (files: value.files, roomId: value.roomId, chattingText: chattingText)
            }
            .flatMap { value in
                ChatManager.sendChat(
                    params: SendChatParams(roomId: value.roomId),
                    body: SendChatBody(
                        content: value.chattingText,
                        files: value.files
                    )
                )
                .catch { error in
                    print(error.errorCode, error.errorDesc)
                    return Single<Chat>.never()
                }
            }
            .subscribe(with: self) { owner, newChat in
                print("업로드 성공!")
                clearSendButtonTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        SocketIOManager.shared.ReceivedChatDataSubject
            .map { receviedChat in

                let sender = UserRepository.shared.read().first { $0.userId == receviedChat.sender.userId }
                let convertedReceviedChat = ChatRoomMessage(
                    chatId: receviedChat.chatId,
                    roomId: receviedChat.roomId,
                    content: receviedChat.content,
                    createdAt: receviedChat.createdAt,
                    sender: sender,
                    files: receviedChat.files
                )
                
                ChatRoomRepository.shared.appendNewRecentChat(convertedReceviedChat)
                                
                return ChatRoomRepository.shared.readMessages(receviedChat.roomId)
            }
            .withUnretained(self)
            .map { owner, updatedChattingList in
                owner.chattingListSubject.onNext(updatedChattingList)
                
                let chattingList: [ChatRoomMessage] = updatedChattingList
                return chattingList.last
            }
            .withLatestFrom(roomInfoSubject) { (lastMessage: $0, chatRoom: $1) }
            .subscribe(with: self) { owner, value in
                guard 
                    let lastMessage = value.lastMessage,
                    let chatRoom = value.chatRoom
                else { return }
                
                let files: [String] = lastMessage.files.map { $0 }
                
                let lastChat = LastChatMessage(
                    chatId: lastMessage.chatId,
                    roomId: lastMessage.roomId,
                    content: lastMessage.content,
                    createdAt: lastMessage.createdAt,
                    sender: lastMessage.sender,
                    files: files
                )
                
                ChatRoomRepository.shared.updateLastChat(lastChat, chatRoom: chatRoom)

                owner.roomInfoSubject.onNext(chatRoom)
            }
            .disposed(by: disposeBag)
        
        input.addImagesButtonTap
            .withLatestFrom(selectedImageDataListRelay)
            .bind { selectedImageList in
                if selectedImageList.count >= 5 {
                    showImageCountIimitAlertTrigger.accept(())
                } else {
                    showPHPickerTrigger.accept(())
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            chattingText: input.chattingTextEvent.asDriver(onErrorJustReturn: ""),
            chattingDidBeginEditingTrigger: input.didBeginEditing.asDriver(),
            chattingDidEndEditingTrigger: input.didEndEditing.asDriver(),
            chattingSendingValid: chattingSendingValidation.asDriver(),
            clearSendButtonTrigger: clearSendButtonTrigger.asDriver(onErrorJustReturn: ()),
            sections: sectionsRelay.asDriver(), 
            showPHPickerTrigger: showPHPickerTrigger.asDriver(onErrorJustReturn: ()),
            showImageCountIimitAlertTrigger: showImageCountIimitAlertTrigger.asDriver(onErrorJustReturn: ()),
            selectedImageList: selectedImageDataListRelay.asDriver(onErrorJustReturn: [])
        )
    }
    
}
