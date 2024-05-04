//
//  CommentViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/20/24.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

protocol CommentViewModelDelegate: AnyObject {
    func sendUpdatedComments(_ comments: [Comment], postId: String)
}

final class CommentViewModel: ViewModelType {
    
    private let postIdSubject = BehaviorSubject<String>(value: "")
    
    weak var delegate: CommentViewModelDelegate?
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let commentTextEvent: Observable<String>
        let commentDidBeginEditing: ControlEvent<Void>
        let commentDidEndEditing: ControlEvent<Void>
        let sendButtonTap: ControlEvent<Void>
        let commentDeleteEvent: Observable<(ControlEvent<IndexPath>.Element, ControlEvent<Comment>.Element)>
        let baseViewTap: ControlEvent<UITapGestureRecognizer>
    }
    
    struct Output {
        let commentList: Driver<[Comment]>
        let commentText: Driver<String>
        let commentDidBeginEditingTrigger: Driver<Void>
        let commentDidEndEditingTrigger: Driver<Void>
        let sendButtonTapTrigger: Driver<Void>
        let commentSendingValid: Driver<Bool>
        let baseViewTapTrigger: Driver<UITapGestureRecognizer>
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
        let commentSendingValidation = BehaviorRelay<Bool>(value: false)
        
        postIdSubject
            .flatMap {
                PostManager.fetchPost(params: .init(postId: $0))
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<Post>.never()
                    }
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
                .catch { error in
                    print(error.errorCode, error.errorDesc)
                    return Single<Comment>.never()
                }
            }
            .withLatestFrom(commentListRelay) { [$0] + $1 }
            .withLatestFrom(postIdSubject) { ($0, $1) }
            .withUnretained(self)
            .map { owner, value in
                commentListRelay.accept(value.0)
                owner.delegate?.sendUpdatedComments(value.0, postId: value.1)
            }
            
        input.commentDeleteEvent
            .filter {
                $1.creator.userId == UserDefaults.standard.userId
            }
            .map { $1.commentId }
            .withLatestFrom(postIdSubject) { ($1, $0) }
            .flatMap {
                CommentManager.deleteComment(params: .init(postId: $0, commentId: $1))
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<String>.never()
                    }
            }
            .withLatestFrom(commentListRelay) { deletedCommentId, commentList in
                commentList.filter { $0.commentId != deletedCommentId }
            }
            .withLatestFrom(postIdSubject) { ($0, $1) }
            .subscribe(with: self) { owner, value in
                commentListRelay.accept(value.0)
                owner.delegate?.sendUpdatedComments(value.0, postId: value.1)
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
            commentSendingValid: commentSendingValidation.asDriver(),
            baseViewTapTrigger: input.baseViewTap.asDriver()
        )
    }
}
