//
//  HashTagSearchViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/15/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Kingfisher

final class HashTagSearchViewModel: ViewModelType {
    struct PostViewModel {
        let post: Post
        let image: UIImage
    }
    
    var disposeBag = DisposeBag()
    
    let postListRelay = BehaviorRelay<[PostViewModel]>(value: [])
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let searText: ControlProperty<String>
        let searchButtonClicked: ControlEvent<Void>
        let refreshControlValueChanged: ControlEvent<()>
    }
    
    struct Output {
        let postList: Driver<[PostViewModel]>
        let endRefreshControlTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let post = PublishSubject<[Post]>()
        let fetchPostList = PublishSubject<Void>()
        let endRefreshControlTrigger = PublishRelay<Void>()
        
        fetchPostList
            .flatMap { _ in
                PostManager.fetchPostList(
                    query: FetchPostsQuery(
                        next: nil,
                        limit: "30",
                        product_id: APIKeys.productId
                    )
                )
                .catch { error in
                    print(error.errorCode, error.errorDesc)
                    return Single<PostListModel>.never()
                }
            }
            .map { postListModel in
                post.onNext(postListModel.data)
                return ()
            }
            .subscribe { _ in
                endRefreshControlTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        post
            .bind(with: self) { owner, postList in
                owner.getPostViewModels(postList)
            }
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .bind { _ in
                fetchPostList.onNext(())
            }
            .disposed(by: disposeBag)
        
        input.searchButtonClicked
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searText)
            .flatMap { searchText in
                return PostManager.FetchPostWithHashTag(
                    query: FetchPostWithHashTagQuery(
                        next: nil,
                        limit: "30",
                        product_id: APIKeys.productId,
                        hashTag: searchText
                    )
                )
                .catch { error in
                    print(error.errorCode, error.errorDesc)
                    return Single<PostListModel>.never()
                }
            }
            .subscribe { postListModel in
                post.onNext(postListModel.data)
            }
            .disposed(by: disposeBag)
        
        input.refreshControlValueChanged
            .bind { _ in
                fetchPostList.onNext(())
            }
            .disposed(by: disposeBag)
            
        return Output(
            postList: postListRelay.asDriver(), 
            endRefreshControlTrigger: endRefreshControlTrigger.asDriver(onErrorJustReturn: ())
        )
    }
    
}

extension HashTagSearchViewModel {
    func getPostViewModels(_ postList: [Post]) {
        let observables = postList.map { post in
            return Observable.just(post)
                .observe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
                .flatMap { post in
                    CachedImageManager.retrieveCachedImages(post)
                }
        }
        
        Observable.combineLatest(observables)
            .subscribe(with: self) { owner, postList in
                owner.postListRelay.accept(postList)
            }
            .disposed(by: disposeBag)
    }
}
