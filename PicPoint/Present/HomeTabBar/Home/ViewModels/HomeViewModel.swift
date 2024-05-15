//
//  HomeViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/15/24.
//

import Foundation
import RxSwift
import RxCocoa
import CoreLocation

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
    let postTapSubject = PublishSubject<PostLikeType>()
    
    let postLikesList = BehaviorRelay<[(String, [String])]>(value: [])
    private let postList = BehaviorRelay<[PostLikeType]>(value: [])
    private let nextCursor = BehaviorSubject<String?>(value: nil)
    private let networkTrigger = PublishSubject<Void>()
    private let updateUserLocationRelay = PublishRelay<CLLocationCoordinate2D>()

    var disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let addButtonTap: ControlEvent<Void>
        let deletePostTap: PublishSubject<String>
        let postTap: ControlEvent<PostLikeType>
        let refreshControlValueChanged: ControlEvent<()>
        let prefetchItems: ControlEvent<[IndexPath]>
    }
    
    struct Output {
        let postList: Driver<[PostLikeType]>
        let addButtonTapTrigger: Driver<Void>
        let otherOptionsButtonTapTrigger: Driver<String>
        let postId: Driver<String>
        let postTapTrigger: Driver<Post?>
        let moveToProfileTrigger: Driver<String>
        let refreshTrigger: Driver<Void>
        let updateUserLocationTrigger: Driver<CLLocationCoordinate2D>
    }
    
    func transform(input: Input) -> Output {
        let postTapTrigger = PublishRelay<Post?>()
        let likeTrigger = PublishSubject<String>()
        let unlikeTrigger = PublishSubject<String>()
        let refreshTrigger = PublishRelay<Void>()
        
        networkTrigger
            .withLatestFrom(nextCursor)
            .flatMap { nextCursor in
                return PostManager.fetchPostList(query: .init(next: nextCursor,limit: "3", product_id: APIKeys.productId))
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<PostListModel>.never()
                    }
            }
            .withUnretained(self)
            .map { owner, postListModel in
                owner.nextCursor.onNext(postListModel.nextCursor)
                let userLocation = LocationManager.shared.getCurrentUserLocation()
                owner.updateUserLocationRelay.accept(userLocation)
                return postListModel.data.filter { post in
                    guard let locationContents = post.content1?.components(separatedBy: "/") else { return false }
                    let latitude = Double(locationContents[0]) ?? 0
                    let longitude = Double(locationContents[1]) ?? 0
                    let postLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let distance = LocationManager.shared.distanceBetweenLocations(from: userLocation, to: postLocation)
                    return distance <= 3000
                }
            }
            .withUnretained(self)
            .map { owner, filteredPostList -> [PostLikeType] in
                return filteredPostList.map { post in
                    if post.likes.contains(UserDefaultsManager.userId) {
                        return (post, .like, post.likes, post.comments)
                    } else {
                        return (post, .unlike, post.likes, post.comments)
                    }
                }
            }
            .withLatestFrom(postList) { (newPostList: $0, oldPostList: $1) }
            .subscribe(with: self) { owner, value in
                let updatedPostList = value.oldPostList + value.newPostList
                owner.postList.accept(updatedPostList)
            }
            .disposed(by: disposeBag)
        
        input.viewDidLoadTrigger
            .map {
                LocationManager.shared.checkDeviceLocationAuthorization()
            }
            .bind(with: self) { owner, _ in
                owner.networkTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        input.prefetchItems
            .withLatestFrom(postList) { ($0, $1) }
            .withLatestFrom(nextCursor) { value, nextCursor in
                (indexPaths: value.0, postList: value.1, nextCursor: nextCursor)
            }
            .bind(with: self) { owner, value in
                for indexPath in value.indexPaths {
                    if indexPath.row == value.postList.count - 1
                        && Int(value.nextCursor ?? "") != 0 {
                        owner.networkTrigger.onNext(())
                    }
                }
            }
            .disposed(by: disposeBag)
        
        input.refreshControlValueChanged
            .flatMap { _ in
                return PostManager.fetchPostList(query: .init(limit: "3", product_id: APIKeys.productId))
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<PostListModel>.never()
                    }
            }
            .withUnretained(self)
            .map { owner, postListModel in
                owner.nextCursor.onNext(postListModel.nextCursor)
                let userLocation = LocationManager.shared.getCurrentUserLocation()
                owner.updateUserLocationRelay.accept(userLocation)
                return postListModel.data.filter { post in
                    guard let locationContents = post.content1?.components(separatedBy: "/") else { return false }
                    let latitude = Double(locationContents[0]) ?? 0
                    let longitude = Double(locationContents[1]) ?? 0
                    let postLocation = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let distance = LocationManager.shared.distanceBetweenLocations(from: userLocation, to: postLocation)
                    return distance <= 3000
                }
            }
            .withUnretained(self)
            .map { owner, filteredPostList -> [PostLikeType] in
                return filteredPostList.map { post in
                    if post.likes.contains(UserDefaultsManager.userId) {
                        return (post, .like, post.likes, post.comments)
                    } else {
                        return (post, .unlike, post.likes, post.comments)
                    }
                }
            }
            .subscribe(with: self) { owner, newPostList in
                owner.postList.accept(newPostList)
                refreshTrigger.accept(())
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
        
        postTapSubject
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
                        let likes = [UserDefaultsManager.userId] + post.likes
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
                        let likes = post.likes.filter { $0 != UserDefaultsManager.userId }
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
            moveToProfileTrigger: moveToProfileTrigger.asDriver(onErrorJustReturn: ""), 
            refreshTrigger: refreshTrigger.asDriver(onErrorJustReturn: ()),
            updateUserLocationTrigger: updateUserLocationRelay.asDriver(onErrorJustReturn: CLLocationCoordinate2D())
        )
    }
}

extension HomeViewModel: AddPostViewModelDelegate {
    func sendNewPost(_ post: Post) {
        
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
