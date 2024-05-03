//
//  HomeViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/15/24.
//

import Foundation
import RxSwift
import RxCocoa

typealias PostLikeType = (
    post: Post,
    likeType: LikeType,
    likes: [String],
    comments: [Comment]
)

final class HomeViewModel: ViewModelType {
    let otherOptionsButtonTapRelay = PublishRelay<String>()
    let commentButtonTapRelay = PublishRelay<String>()
    let heartButtonTapSubject = PublishSubject<PostLikeType>()
    let profileImageViewTapSubject = PublishSubject<String>()
    
    let postLikesList = BehaviorRelay<[(String, [String])]>(value: [])
    private let postList = BehaviorRelay<[PostLikeType]>(value: [])

    var disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let rightBarButtonItemTapped: ControlEvent<Void>
        let addButtonTap: ControlEvent<Void>
        let deletePostTap: PublishSubject<String>
        let postTap: ControlEvent<PostLikeType>
    }
    
    struct Output {
        let postList: Driver<[PostLikeType]>
        let addButtonTapTrigger: Driver<Void>
        let otherOptionsButtonTapTrigger: Driver<String>
        let postId: Driver<String>
        let postTapTrigger: Driver<Post?>
        let moveToProfileTrigger: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let postTapTrigger = PublishRelay<Post?>()
        let likeTrigger = PublishSubject<String>()
        let unlikeTrigger = PublishSubject<String>()
        
        input.viewDidLoadTrigger
            .flatMap { _ in
                PostManager.fetchPostList(query: .init(limit: "50", product_id: APIKeys.productId))
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<PostListModel>.never()
                    }
            }
            .map { postListModel -> [PostLikeType] in
                postListModel.data.map { post in
                    if post.likes.contains(UserDefaults.standard.userId) {
                        return (post, .like, post.likes, post.comments)
                    } else {
                        return (post, .unlike, post.likes, post.comments)
                    }
                }
            }
            .subscribe(with: self) { owner, newPostList in
                owner.postList.accept(newPostList)
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
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<String>.never()
                    }
            }
            .withLatestFrom(postList) { deletedMyPostId, postList in
                NotificationCenter.default.post(name: .sendDeletedMyPostId, object: nil, userInfo: ["deletedMyPostId": deletedMyPostId])
                return postList.filter { post in
                    post.post.postId != deletedMyPostId
                }
            }
            .subscribe(with: self) { owner, filteredPostList in
                owner.postList.accept(filteredPostList)
            }
            .disposed(by: disposeBag)
        
        input.postTap
            .flatMap {
                PostManager.fetchPost(params: FetchPostParams(postId: $0.post.postId))
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<Post>.never()
                    }
            }
            .subscribe {
                print("fetch 완료")
                postTapTrigger.accept($0)
            }
            .disposed(by: disposeBag)
        
        likeTrigger
            .flatMap {
                LikeManager.like(
                    params: LikeParams(postId: $0),
                    body: LikeBody(like_status: true)
                )
                .catch { error in
                    print(error.errorCode, error.errorDesc)
                    return Single<String>.never()
                }
            }
            .withLatestFrom(postList) { postId, postList -> [PostLikeType] in
                var newLikedPost: Post?
                let newPostList: [PostLikeType] = postList.map { post in
                    if post.post.postId == postId {
                        newLikedPost = post.post
                        let likes = [UserDefaults.standard.userId] + post.likes
                        return (post.post, .like, likes, post.comments)
                    } else {
                        return post
                    }
                }
                if let newLikedPost {
                    NotificationCenter.default.post(name: .sendNewLikedPost, object: nil, userInfo: ["newLikedPost": newLikedPost])
                }
                return newPostList
            }
            .subscribe(with: self) { owner, newPostList in
                print("like")
                owner.postList.accept(newPostList)
            }
            .disposed(by: disposeBag)
        
        unlikeTrigger
            .flatMap {
                LikeManager.unlike(
                    params: LikeParams(postId: $0),
                    body: LikeBody(like_status: false)
                )
                .catch { error in
                    print(error.errorCode, error.errorDesc)
                    return Single<String>.never()
                }
            }
            .withLatestFrom(postList) { postId, postList -> [PostLikeType] in
                var unlikedPost: Post?
                let newPostList: [PostLikeType] = postList.map { post in
                    if post.post.postId == postId {
                        unlikedPost = post.post
                        let likes = post.likes.filter { $0 != UserDefaults.standard.userId }
                        return (post.post, .unlike, likes, post.comments)
                    } else {
                        return post
                    }
                }
                if let unlikedPost {
                    NotificationCenter.default.post(name: .sendUnlikedPost, object: nil, userInfo: ["unlikedPost": unlikedPost])
                }
                return newPostList
            }
            .subscribe(with: self) { owner, newPostList in
                print("unlike")
                owner.postList.accept(newPostList)
            }
            .disposed(by: disposeBag)
        
        heartButtonTapSubject
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe { post in
                switch post.likeType {
                case .like:
                    unlikeTrigger.onNext(post.post.postId)
                case .unlike:
                    likeTrigger.onNext(post.post.postId)
                case .none: break
                }
            }
            .disposed(by: disposeBag)
        
        let moveToProfileTrigger = profileImageViewTapSubject
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            
        return Output(
            postList: postList.asDriver(),
            addButtonTapTrigger: input.addButtonTap.asDriver(),
            otherOptionsButtonTapTrigger: otherOptionsButtonTapRelay.asDriver(onErrorJustReturn: ""),
            postId: commentButtonTapRelay.asDriver(onErrorJustReturn: ""), 
            postTapTrigger: postTapTrigger.asDriver(onErrorJustReturn: nil),
            moveToProfileTrigger: moveToProfileTrigger.asDriver(onErrorJustReturn: "")
        )
    }
}

extension HomeViewModel: AddPostViewModelDelegate {
    func sendNewPost(_ post: Post) {
        print("new post", post)
        
        Observable<Post>.just(post)
            .withLatestFrom(postList) { newPost, postList in
                return [(newPost, .unlike, [], [])] + postList
            }
            .subscribe(with: self) { owner, newPostList in
                owner.postList.accept(newPostList)
            }
            .disposed(by: disposeBag)
    }
}

extension HomeViewModel: DetailViewModelDelegate {
    func sendLikeUpdateTrigger(_ post: PostLikeType?) {
        guard let updatedPost = post else { return }
            Observable.just(updatedPost)
            .withLatestFrom(postList) { updatedPost, postList in
                postList.map { post in
                    if post.post.postId == updatedPost.post.postId {
                        return updatedPost
                    } else {
                         return post
                    }
                }
            }
            .subscribe(with: self) { owner, updatePostList in
                owner.postList.accept(updatePostList)
            }
            .disposed(by: disposeBag)
    }
}

extension HomeViewModel: CommentViewModelDelegate {
    func sendUpdatedComments(_ comments: [Comment], postId: String) {
        Observable<[Comment]>.just(comments)
            .withLatestFrom(postList) { updatedComments, postList in
                postList.map { post in
                    if post.post.postId == postId {
                        return (post.post, post.likeType, post.likes, updatedComments)
                    } else {
                        return post
                    }
                }
            }
            .subscribe(with: self) { owner, updatedPostList in
                owner.postList.accept(updatedPostList)
            }
            .disposed(by: disposeBag)
    }
}
