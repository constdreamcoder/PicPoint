//
//  MyPostViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/26/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol MyPostViewModelDelegate: AnyObject {
    func sendMyPostCollectionViewContentHeight(_ contentHeight: CGFloat)
}

final class MyPostViewModel: ViewModelType {
    
    private let myPostsList = BehaviorRelay<[Post]>(value: [])
    
    var disposeBag = DisposeBag()
    
    weak var delegate: MyPostViewModelDelegate?
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let myPostsList: Driver<[Post]>
    }
    
    func transform(input: Input) -> Output {
        
        
        
        return Output(myPostsList: myPostsList.asDriver())
    }
    
}

extension MyPostViewModel: ProfileViewModelDelegate {
    func sendMyPosts(_ posts: [String]) {
        print("posts", posts)
        //        Observable.just(posts)
        //            .subscribe(with: self) { owner, posts in
        //                owner.myPostsIdList.onNext(posts)
        //            }
        //            .disposed(by: disposeBag)
        
        let observables = posts.map { id in
            return Observable.just(id)
                .observe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
                .flatMap { id in
                    return PostManager.fetchPost(params: FetchPostParams(postId: id))
                }
        }
        
        Observable.combineLatest(observables)
            .subscribe(with: self) { owner, postList in
                owner.myPostsList.accept(postList)
            }
            .disposed(by: disposeBag)
    }
}
