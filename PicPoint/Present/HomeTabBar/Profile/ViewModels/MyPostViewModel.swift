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
    func sendNewPostId(_ postId: String)
    func sendUpdatedPostIdList(_ postIdList: [String])
    func sendPostForMovingToDetailVCFromMyPostVC(_ post: Post)
    func sendPostListBackToProfileVC(_ postList: [Post])
}

final class MyPostViewModel: ViewModelType {
    
    private let myPostsList = BehaviorRelay<[Post]>(value: [])
    
    var disposeBag = DisposeBag()
    
    weak var delegate: MyPostViewModelDelegate?
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let postTap: ControlEvent<Post>
    }
    
    struct Output {
        let myPostsList: Driver<[Post]>
    }
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewPost), name: .sendNewPost, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdatedPostList), name: .sendDeletedMyPostId, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .sendNewPost, object: nil)
        NotificationCenter.default.removeObserver(self, name: .sendDeletedMyPostId, object: nil)
    }
    
    func transform(input: Input) -> Output {
        input.postTap
            .flatMap {
                PostManager.fetchPost(params: FetchPostParams(postId: $0.postId))
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<Post>.never()
                    }
            }
            .subscribe(with: self) { onwer, post in
                print("fetch 완료")
                onwer.delegate?.sendPostForMovingToDetailVCFromMyPostVC(post)
            }
            .disposed(by: disposeBag)
    
        return Output(
            myPostsList: myPostsList.asDriver()
        )
    }
    
}

extension MyPostViewModel: ProfileViewModelDelegate {
    func sendMyPosts(_ posts: [String]) {
        let observables = posts.map { id in
            return Observable.just(id)
                .observe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
                .flatMap {
                    PostManager.fetchPost(params: FetchPostParams(postId: $0))
                        .catch { error in
                            print(error.errorCode, error.errorDesc)
                            return Single<Post>.never()
                        }
                }
        }
        
        Observable.combineLatest(observables)
            .subscribe(with: self) { owner, postList in
                owner.myPostsList.accept(postList)
                owner.delegate?.sendPostListBackToProfileVC(postList)
            }
            .disposed(by: disposeBag)
        
    }
}

extension MyPostViewModel {
    @objc func handleNewPost(notification: Notification) {
        if let userInfo = notification.userInfo,
           let newPost = userInfo["newPost"] as? Post {
            
            Observable<Post>.just(newPost)
                .withLatestFrom(myPostsList)
                .subscribe(with: self) { owner, postList in
                    owner.myPostsList.accept(postList + [newPost])
                    owner.delegate?.sendNewPostId(newPost.postId)
                }
                .disposed(by: disposeBag)
        }
    }
    
    @objc func handleUpdatedPostList(notification: Notification) {
        if let userInfo = notification.userInfo,
           let deletedMyPostId = userInfo["deletedMyPostId"] as? String {
            Observable<String>.just(deletedMyPostId)
                .withLatestFrom(myPostsList) { deletedMyPostId, myPostList in
                    myPostList.filter { $0.postId !=  deletedMyPostId }
                }
                .subscribe(with: self) { owner, updatedPostList in
                    owner.myPostsList.accept(updatedPostList)
                    owner.delegate?.sendUpdatedPostIdList(updatedPostList.map { $0.postId })
                }
                .disposed(by: disposeBag)
        }
    }
}
