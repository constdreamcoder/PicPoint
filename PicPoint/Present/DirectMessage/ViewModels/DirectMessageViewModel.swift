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

    struct Input {
        let commentTextEvent: Observable<String>
        let didBeginEditing: ControlEvent<Void>
        let didEndEditing: ControlEvent<Void>
        let sendButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let commentText: Driver<String>
        let commentDidBeginEditingTrigger: Driver<Void>
        let commentDidEndEditingTrigger: Driver<Void>
        let commentSendingValid: Driver<Bool>
        let sendButtonTapTrigger: Driver<Void>
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
    
    deinit {
        print("deinit - DirectMessageViewModel")
        SocketIOManager.shared.leaveConnection()
        SocketIOManager.shared.removeAllEventHandlers()
    }
    
    func transform(input: Input) -> Output {
        let commentSendingValidation = BehaviorRelay<Bool>(value: false)
        
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
        
        let commentTextEventTrigger = input.commentTextEvent
            .map {
                if $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    commentSendingValidation.accept(false)
                } else {
                    commentSendingValidation.accept(true)
                }
                return $0
            }
        
        let sendButtonTapTrigger = input.sendButtonTap
            .debounce(.milliseconds(200), scheduler: MainScheduler.instance)
        
        return Output(
            commentText: commentTextEventTrigger.asDriver(onErrorJustReturn: ""),
            commentDidBeginEditingTrigger: input.didBeginEditing.asDriver(),
            commentDidEndEditingTrigger: input.didEndEditing.asDriver(),
            commentSendingValid: commentSendingValidation.asDriver(),
            sendButtonTapTrigger: sendButtonTapTrigger.asDriver(onErrorJustReturn: ()),
            sections: sectionsRelay.asDriver()
        )
    }
    
}
