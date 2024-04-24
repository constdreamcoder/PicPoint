//
//  HomeViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/15/24.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {
    let otherOptionsButtonTap = PublishRelay<String>()
    let commentButtonTap = PublishRelay<String>()

    var disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let rightBarButtonItemTapped: ControlEvent<Void>
        let addButtonTap: ControlEvent<Void>
        let deletePostTap: PublishSubject<String>
        let postTap: ControlEvent<Post>
    }
    
    struct Output {
        let postList: Driver<[Post]>
        let addButtonTapTrigger: Driver<Void>
        let otherOptionsButtonTapTrigger: Driver<String>
        let postId: Driver<String>
        let postTapTrigger: Driver<Post?>
    }
    
    func transform(input: Input) -> Output {
        let postList = BehaviorRelay<[Post]>(value: [])
        let postTapTrigger = PublishRelay<Post?>()
        
        input.viewDidLoadTrigger
            .flatMap { _ in
                PostManager.fetchPostList(query: .init(limit: "50", product_id: APIKeys.productId))
            }
            .subscribe(with: self) { owner, postListModel in
                postList.accept(postListModel.data)
            }
            .disposed(by: disposeBag)
        
        input.rightBarButtonItemTapped
            .bind(with: self) { owner, _ in
                print("검색")
            }
            .disposed(by: disposeBag)
        
        input.deletePostTap
            .flatMap {
                PostManager.deletePost(params: DeletePostParams(postId: $0))
            }
            .subscribe(with: self) { owner, deletedPostId in
                print("삭제가 완료되었습니다.")
                print("deletedPostId", deletedPostId)
            }
            .disposed(by: disposeBag)
        
        input.postTap
            .flatMap {
                PostManager.fetchPost(params: FetchPostParams(postId: $0.postId))
            }
            .subscribe {
                print("fetch 완료")
                postTapTrigger.accept($0)
            }
            .disposed(by: disposeBag)
            
        
        return Output(
            postList: postList.asDriver(),
            addButtonTapTrigger: input.addButtonTap.asDriver(),
            otherOptionsButtonTapTrigger: otherOptionsButtonTap.asDriver(onErrorJustReturn: ""),
            postId: commentButtonTap.asDriver(onErrorJustReturn: ""), 
            postTapTrigger: postTapTrigger.asDriver(onErrorJustReturn: nil)
        )
    }
}
