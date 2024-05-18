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
    
    private let roomInfoSubject = BehaviorSubject<CreateRoomModel?>(value: nil)
    private let chattingListSubject = BehaviorSubject<[Chat]>(value: [])
    private let sectionsRelay = BehaviorRelay<[DirectMessageTableViewSectionDataModel]>(value: [])
    private let chattingTextSubject = PublishSubject<String>()

    struct Input {
        let chattingTextEvent: Observable<String>
        let didBeginEditing: ControlEvent<Void>
        let didEndEditing: ControlEvent<Void>
        let sendButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let chattingText: Driver<String>
        let chattingDidBeginEditingTrigger: Driver<Void>
        let chattingDidEndEditingTrigger: Driver<Void>
        let chattingSendingValid: Driver<Bool>
        let clearSendButtonTrigger: Driver<Void>
        let sections: Driver<[DirectMessageTableViewSectionDataModel]>
    }
    
    init(_ createRoomModel: CreateRoomModel) {
        Observable.just(createRoomModel)
            .withUnretained(self)
            .map { owner, createRoomModel -> (roomId: String, lastChat: Chat?) in
                SocketIOManager.shared.setupSocketEventListeners(createRoomModel.roomId)
                
                owner.roomInfoSubject.onNext(createRoomModel)
                return (createRoomModel.roomId, createRoomModel.lastChat)
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
        
        let chattingTextEventTrigger = input.chattingTextEvent
            .withUnretained(self)
            .map { owner, chattingText in
                if chattingText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    chattingSendingValidation.accept(false)
                } else {
                    chattingSendingValidation.accept(true)
                    owner.chattingTextSubject.onNext(chattingText)
                }
                return chattingText
            }
        
        input.sendButtonTap
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
            .withLatestFrom(roomInfoSubject)
            .withLatestFrom(chattingTextSubject) {
                (roomId: $0?.roomId ?? "", chattingText: $1)
            }
            .flatMap { value in
                ChatManager.sendChat(
                    params: SendChatParams(roomId: value.roomId),
                    body: SendChatBody(content: value.chattingText)
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
            .withLatestFrom(chattingListSubject) { newChat, chattingList in
                var chattingList = chattingList
                chattingList.append(newChat)
                return chattingList
            }
            .subscribe(with: self) { owner, updatedChattingList in
                owner.chattingListSubject.onNext(updatedChattingList)
                clearSendButtonTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        return Output(
            chattingText: chattingTextEventTrigger.asDriver(onErrorJustReturn: ""),
            chattingDidBeginEditingTrigger: input.didBeginEditing.asDriver(),
            chattingDidEndEditingTrigger: input.didEndEditing.asDriver(),
            chattingSendingValid: chattingSendingValidation.asDriver(),
            clearSendButtonTrigger: clearSendButtonTrigger.asDriver(onErrorJustReturn: ()),
            sections: sectionsRelay.asDriver()
        )
    }
    
}
