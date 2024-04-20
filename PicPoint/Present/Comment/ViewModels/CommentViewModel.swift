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
        
    }
    
    struct Output {
        let commentList: Driver<[Comment]>
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
        
        postIdSubject
            .flatMap {
                PostManager.fetchPost(params: .init(postId: $0))
            }
            .subscribe(with: self) { owner, post in
                commentListRelay.accept(post.comments)
            }
            .disposed(by: disposeBag)
        
        return Output(
            commentList: commentListRelay.asDriver()
        )
    }
}
