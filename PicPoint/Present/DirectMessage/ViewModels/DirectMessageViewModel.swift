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
    }
    
    func transform(input: Input) -> Output {
        let commentSendingValidation = BehaviorRelay<Bool>(value: false)
        
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
            sendButtonTapTrigger: sendButtonTapTrigger.asDriver(onErrorJustReturn: ())
        )
    }
    
}
