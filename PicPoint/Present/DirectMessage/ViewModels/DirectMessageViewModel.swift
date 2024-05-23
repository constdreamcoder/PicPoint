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
    private let roomInfoSubject = BehaviorSubject<Room?>(value: nil)
    private let chattingListSubject = BehaviorSubject<[Chat]>(value: [])
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
    
    init(_ room: Room) {
        Observable.just(room)
            .withUnretained(self)
            .map { owner, room -> (roomId: String, lastChat: Chat?) in
                SocketIOManager.shared.setupSocketEventListeners(room.roomId)
                
                owner.roomInfoSubject.onNext(room)
                return (room.roomId, room.lastChat)
            }
            .flatMap { value in
                ChatManager.fetchChattingHistory(
                    params: FetchChattingHistoryParams(roomId: value.roomId),
                    //                    query: FetchChattingHistoryQuery(cursor_date: value.lastChat?.createdAt)
                    query: FetchChattingHistoryQuery(cursor_date: nil)
                )
                .catch { error in
                    print(error.errorCode, error.errorDesc)
                    return Single<ChattingListModel>.never()
                }
            }
            .subscribe(with: self) { owner, chattingListModel in
                // TODO: - DB에 저장되어 있는 채팅 내역 불러와서 append하기
                owner.chattingListSubject.onNext(chattingListModel.data)
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
                (files: value.1, roomId: value.0, chattingText: chattingText)
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
            .map { newChat in
                // TODO: - DB에 저장하고 다시 불러오기
                return newChat
            }
            .subscribe(with: self) { owner, _ in
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
            .map { newChat in
                // TODO: - DB에 저장하고 다시 불러오기
                return newChat
            }
            .subscribe(with: self) { owner, _ in
                print("업로드 성공!")
                clearSendButtonTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        SocketIOManager.shared.ReceivedChatDataSubject
            .withLatestFrom(chattingListSubject) { receviedChat, chattingList in
                var chattingList = chattingList
                chattingList.append(receviedChat)
                return chattingList
            }
            .subscribe(with: self) { owner, updatedChattingList in
                owner.chattingListSubject.onNext(updatedChattingList)
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
