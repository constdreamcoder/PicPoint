//
//  DetailViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/17/24.
//

import Foundation
import RxSwift
import RxCocoa
import Differentiator
import CoreLocation

protocol DetailViewModelDelegate: AnyObject {
    func sendLikeUpdateTrigger(_ post: PostLikeType?)
}

final class DetailViewModel: ViewModelType {
    
    let followButtonTapTriggerRelay = BehaviorRelay<Bool>(value: false)
    let followButtonTapSubject = PublishSubject<Creator>()
    let mapViewTapRelay = PublishRelay<CLLocationCoordinate2D>()
    let profileImageViewTapTapSubject = PublishSubject<String>()
    
    private let sectionsRelay = BehaviorRelay<[SectionModelWrapper]>(value: [])
    private let postRelay = BehaviorRelay<PostLikeType?>(value: nil)
    private let hashTagsSubject = BehaviorSubject<[String]>(value: [])
    private let relatedPostList = BehaviorSubject<[Post]>(value: [])
    
    weak var delegate: DetailViewModelDelegate?
    
    var disposeBag = DisposeBag()

    struct Input {
        let heartButtonTap: ControlEvent<Void>
        let commentButtonTap: ControlEvent<Void>
        let itemTap: PublishSubject<Int>
    }
    
    struct Output {
        let sections: Driver<[SectionModelWrapper]>
        let post: Driver<PostLikeType?>
        let postId: Driver<String>
        let mapViewTapTrigger: Driver<CLLocationCoordinate2D>
        let itemTapTrigger: Driver<Post?>
        let moveToOtherProfileTrigger: Driver<String>
    }
    
    init(post: Post) {
        Observable.just(post)
            .withUnretained(self)
            .map { owner, post in
                if post.likes.contains(where: { $0 == UserDefaults.standard.userId }) {
                    let postLike: PostLikeType = (post, .like, post.likes, post.comments)
                    owner.postRelay.accept(postLike)
                } else {
                    let postLike: PostLikeType = (post, .unlike, post.likes, post.comments)
                    owner.postRelay.accept(postLike)
                }
                return post
            }
            .withUnretained(self)
            .map { owner, post -> FetchPostWithHashTagQuery in
                owner.hashTagsSubject.onNext(post.hashTags)
                return FetchPostWithHashTagQuery(
                    limit: "10",
                    hashTag: post.hashTags.count == 0 ? "" : post.hashTags[0]
                )
            }
            .flatMap { fetchPostWithHashTagQuery in
                PostManager.FetchPostWithHashTag(query: fetchPostWithHashTagQuery)
            }
            .subscribe(with: self) { owner, postList in
                let separatedLocationStrings = post.content1?.components(separatedBy: "/")
                
                let latitude = Double(separatedLocationStrings?[0] ?? "") ?? 0
                let longitude = Double(separatedLocationStrings?[1] ?? "") ?? 0
                
                let separatedDateStrings = post.content2?.components(separatedBy: "/")
                
                let sections: [SectionModelWrapper] = [
                    SectionModelWrapper(
                        DetailCollectionViewFirstSectionDataModel(
                            items: [.init(
                                header: "",
                                title: post.title ?? "", 
                                address: separatedLocationStrings?[3] ?? "",
                                files: post.files)
                            ]
                        )
                    ),
                    SectionModelWrapper(
                        DetailCollectionViewSecondSectionDataModel(
                            items: [.init(
                                header: "",
                                content: post.content ?? "",
                                visitDate: separatedDateStrings?[0].getDateString ?? "",
                                creator: post.creator)
                            ]
                        )
                    ),
                    SectionModelWrapper(
                        DetailCollectionViewThirdSectionDataModel(
                            header: "",
                            items: [.init(
                                header: "",
                                latitude: latitude,
                                longitude: longitude,
                                longAddress: separatedLocationStrings?[2] ?? "",
                                hashTags: post.hashTags, 
                                recommendedVisitTime: separatedDateStrings?[1] ?? "")
                            ]
                        )
                    ),
                    SectionModelWrapper(
                        DetailCollectionViewForthSectionDataModel(
                            header: "", 
                            items: postList.filter { $0.postId != post.postId }
                        )
                    )
                ]
                owner.sectionsRelay.accept(sections)
                owner.relatedPostList.onNext(postList.filter { $0.postId != post.postId })
            }
            .disposed(by: disposeBag)
    }
    
    func transform(input: Input) -> Output {
        let postIdRelay = PublishRelay<String>()
        let itemTapTrigger = PublishRelay<Post?>()
        let likeTrigger = PublishSubject<String>()
        let unlikeTrigger = PublishSubject<String>()
        let followTrigger = PublishSubject<Post>()
        let unFollowTrigger = PublishSubject<Post>()

        likeTrigger
            .flatMap {
                LikeManager.like(
                    params: LikeParams(postId: $0),
                    body: LikeBody(like_status: true)
                )
            }
            .withLatestFrom(postRelay)
            .map { post -> PostLikeType? in
                if let post {
                    NotificationCenter.default.post(name: .sendNewLikedPost, object: nil, userInfo: ["newLikedPost": post.post])
                    let likes = [UserDefaults.standard.userId] + post.likes
                    return (post.post, .like, likes, post.comments)
                } else {
                    return post
                }
            }
            .subscribe(with: self) { owner, updatedPost in
                owner.postRelay.accept(updatedPost)
                owner.delegate?.sendLikeUpdateTrigger(updatedPost)
            }
            .disposed(by: disposeBag)
        
        unlikeTrigger
            .flatMap {
                LikeManager.unlike(
                    params: LikeParams(postId: $0),
                    body: LikeBody(like_status: false)
                )
            }
            .withLatestFrom(postRelay)
            .map { post -> PostLikeType? in
                if let post {
                    NotificationCenter.default.post(name: .sendUnlikedPost, object: nil, userInfo: ["unlikedPost": post.post])
                    let likes = post.likes.filter { $0 != UserDefaults.standard.userId }
                    return (post.post, .unlike, likes, post.comments)
                } else {
                    return post
                }
            }
            .subscribe(with: self) { owner, updatedPost in
                owner.postRelay.accept(updatedPost)
                owner.delegate?.sendLikeUpdateTrigger(updatedPost)
            }
            .disposed(by: disposeBag)
        
        input.heartButtonTap
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .withLatestFrom(postRelay)
            .subscribe { post in
                guard let post else { return }
                switch post.likeType {
                case .like:
                    unlikeTrigger.onNext(post.post.postId)
                case .unlike:
                    likeTrigger.onNext(post.post.postId)
                case .none: break
                }
            }
            .disposed(by: disposeBag)
        
        postRelay
            .bind(with: self) { owner, post in
                if let post {
                    if UserDefaults.standard.followings.contains(where: { $0.userId == post.post.creator.userId }) {
                        owner.followButtonTapTriggerRelay.accept(true)
                    } else {
                        owner.followButtonTapTriggerRelay.accept(false)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        followTrigger
            .flatMap {
                let newFollowing = Following(
                    userId: $0.creator.userId,
                    nick: $0.creator.nick,
                    profileImage: $0.creator.profileImage
                )
                UserDefaults.standard.followings.append(newFollowing)
                return FollowManager.follow(params: FollowParams(userId: $0.creator.userId))
            }
            .subscribe(with: self) { owner, _ in
                owner.followButtonTapTriggerRelay.accept(true)
            }
            .disposed(by: disposeBag)
        
        unFollowTrigger
            .flatMap { post in
                UserDefaults.standard.followings.removeAll(where: { $0.userId == post.creator.userId })
                return FollowManager.unfollow(params: UnFollowParams(userId: post.creator.userId))
            }
            .subscribe(with: self) { owner, _ in
                owner.followButtonTapTriggerRelay.accept(false)
            }
            .disposed(by: disposeBag)
        
        followButtonTapSubject
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(postRelay) { ($0, $1) }
            .subscribe { creator, post in
                guard let post else { return }
                if UserDefaults.standard.followings.contains(where: { $0.userId == creator.userId }) {
                    unFollowTrigger.onNext(post.post)
                } else {
                    followTrigger.onNext(post.post)
                }
            }
            .disposed(by: disposeBag)
        
        input.commentButtonTap
            .withLatestFrom(postRelay)
            .subscribe { post in
                guard let post else { return }
                postIdRelay.accept(post.post.postId)
            }
            .disposed(by: disposeBag)
        
       input.itemTap
            .withLatestFrom(relatedPostList) { tappedItemIndex, relatedPostList in
                relatedPostList[tappedItemIndex].postId
            }
            .flatMap { postId in
                PostManager.fetchPost(params: FetchPostParams(postId: postId))
            }
            .subscribe { itemTapTrigger.accept($0) }
            .disposed(by: disposeBag)
        
        let moveToOtherProfileTrigger = profileImageViewTapTapSubject
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)

        return Output(
            sections: sectionsRelay.asDriver(onErrorJustReturn: []), 
            post: postRelay.asDriver(), 
            postId: postIdRelay.asDriver(onErrorJustReturn: ""), 
            mapViewTapTrigger: mapViewTapRelay.asDriver(onErrorJustReturn: CLLocationCoordinate2D()),
            itemTapTrigger: itemTapTrigger.asDriver(onErrorJustReturn: nil),
            moveToOtherProfileTrigger: moveToOtherProfileTrigger.asDriver(onErrorJustReturn: "")
        )
    }
}

extension DetailViewModel: CommentViewModelDelegate {
    func sendUpdatedComments(_ comments: [Comment], postId: String) {
        Observable<[Comment]>.just(comments)
            .withLatestFrom(postRelay) { updatedCommentList, post -> PostLikeType? in
                if let post, post.post.postId == postId {
                    return (post.post, post.likeType, post.likes, updatedCommentList)
                } else {
                     return post
                }
            }
            .subscribe(with: self) { owner, updatePost in
                owner.postRelay.accept(updatePost)
                owner.delegate?.sendLikeUpdateTrigger(updatePost)
            }
            .disposed(by: disposeBag)
    }
}
