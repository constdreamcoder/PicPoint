//
//  CommentViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/20/24.
//

import Foundation
import RxSwift
import RxCocoa

final class CommentViewModel: ViewModelType {
    
    private let postIdSubject = BehaviorSubject<String>(value: "")
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let commentTextEvent: ControlProperty<String>
        let commentDidBeginEditing: ControlEvent<Void>
        let commentDidEndEditing: ControlEvent<Void>
        let sendButtonTap: ControlEvent<Void>
        let commentDeleteEvent: Observable<(ControlEvent<IndexPath>.Element, ControlEvent<Comment>.Element)>
    }
    
    struct Output {
        let commentList: Driver<[Comment]>
        let commentText: Driver<String>
        let commentDidBeginEditingTrigger: Driver<Void>
        let commentDidEndEditingTrigger: Driver<Void>
        let sendButtonTapTrigger: Driver<Void>
        let commentSendingValid: Driver<Bool>
    }
    
    init(postId: String) {
        Observable.just(postId)
            .subscribe(with: self) { owner, postId in
                owner.postIdSubject.onNext(postId)
            }
            .disposed(by: disposeBag)
    }
    
    func transform(input: Input) -> Output {
        let commentListRelay = BehaviorRelay<[Comment]>(value: [])
        let commentSendingValidation = BehaviorRelay(value: false)
        
        postIdSubject
            .flatMap {
                PostManager.fetchPost(params: .init(postId: $0))
            }
            .subscribe(with: self) { owner, post in
                commentListRelay.accept(post.comments)
            }
            .disposed(by: disposeBag)
        
        let sendButtonTapTrigger = input.sendButtonTap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(postIdSubject)
            .withLatestFrom(input.commentTextEvent) { ($0, $1) }
            .flatMap {
                CommentManager.writeComment(
                    params: .init(postId: $0),
                    body: .init(content: $1)
                )
            }
            .withLatestFrom(commentListRelay) { [$0] + $1 }
            .map { commentListRelay.accept($0) }
            
        
        input.commentDeleteEvent
            .map { $1.commentId }
            .withLatestFrom(postIdSubject) { ($1, $0) }
            .flatMap {
                CommentManager.deleteComment(params: .init(postId: $0, commentId: $1))
            }
            .withLatestFrom(commentListRelay) { deletedCommentId, commentList in
                commentList.filter { $0.commentId != deletedCommentId }
            }
            .subscribe(with: self) { owner, updatedCommentList in
                commentListRelay.accept(updatedCommentList)
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
        
        return Output(
            commentList: commentListRelay.asDriver(),
            commentText: commentTextEventTrigger.asDriver(onErrorJustReturn: ""),
            commentDidBeginEditingTrigger: input.commentDidBeginEditing.asDriver(),
            commentDidEndEditingTrigger: input.commentDidEndEditing.asDriver(),
            sendButtonTapTrigger: sendButtonTapTrigger.asDriver(onErrorJustReturn: ()),
            commentSendingValid: commentSendingValidation.asDriver()
        )
    }
}
