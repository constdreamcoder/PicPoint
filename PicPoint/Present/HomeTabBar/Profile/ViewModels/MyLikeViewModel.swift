//
//  MyLikeViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/26/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol MyLikeViewModelDelegate: AnyObject {
    func sendMyLikeCollectionViewContentHeight(_ contentHeight: CGFloat)
    func sendPostForMovingToDetailVCFromMyLikeVC(_ post: Post)
}

final class MyLikeViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    private let likedPostList = BehaviorRelay<[Post]>(value: [])
    
    weak var delegate: MyLikeViewModelDelegate?

    struct Input {
        let viewDidLoad: Observable<Void>
        let postTap: ControlEvent<Post>
    }
    
    struct Output {
        let viewDidLoadTrigger: Driver<[Post]>
    }
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNewLikedPost), name: .sendNewLikedPost, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUnlikedPost), name: .sendUnlikedPost, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .sendNewLikedPost, object: nil)
        NotificationCenter.default.removeObserver(self, name: .sendUnlikedPost, object: nil)
    }
    
    func transform(input: Input) -> Output {
        
        input.viewDidLoad
            .flatMap {
                LikeManager.fetchMyLikes()
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<[Post]>.never()
                    }
            }
            .subscribe(with: self) { owner, likedPostList in
                owner.likedPostList.accept(likedPostList)
            }
            .disposed(by: disposeBag)
        
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
                onwer.delegate?.sendPostForMovingToDetailVCFromMyLikeVC(post)
            }
            .disposed(by: disposeBag)
        
            
        return Output(
            viewDidLoadTrigger: likedPostList.asDriver()
        )
    }
}

extension MyLikeViewModel {
    @objc func handleNewLikedPost(notification: Notification) {
        if let userInfo = notification.userInfo,
           let newLikedPost = userInfo["newLikedPost"] as? Post {
            Observable<Post>.just(newLikedPost)
                .withLatestFrom(likedPostList) { $1 + [$0] }
                .subscribe(with: self) { owner, updatedLikedPostList in
                    owner.likedPostList.accept(updatedLikedPostList)
                }
                .disposed(by: disposeBag)
        }
    }
    
    @objc func handleUnlikedPost(notification: Notification) {
        if let userInfo = notification.userInfo,
           let unlikedPost = userInfo["unlikedPost"] as? Post {
            Observable<Post>.just(unlikedPost)
                .withLatestFrom(likedPostList) { unlikedPost, likedPostList in
                    likedPostList.filter { $0.postId != unlikedPost.postId }
                }
                .subscribe(with: self) { owner, updatedLikedPostList in
                    owner.likedPostList.accept(updatedLikedPostList)
                }
                .disposed(by: disposeBag)
        }
    }
}
