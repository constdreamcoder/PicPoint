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
import iamport_ios

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
        let rightBarButtonItem: ControlEvent<Void>
        let heartButtonTap: ControlEvent<Void>
        let commentButtonTap: ControlEvent<Void>
        let itemTap: PublishSubject<Int>
        let paymentResponse: PublishSubject<IamportResponse>
    }
    
    struct Output {
        let rightBarButtonItemHiddenTrigger: Driver<Bool>
        let sections: Driver<[SectionModelWrapper]>
        let post: Driver<PostLikeType?>
        let postId: Driver<String>
        let mapViewTapTrigger: Driver<CLLocationCoordinate2D>
        let itemTapTrigger: Driver<Post?>
        let moveToOtherProfileTrigger: Driver<String>
        let gotoPaymentPageTrigger: Driver<IamportPayment?>
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
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<[Post]>.never()
                    }
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
        let gotoPaymentPageTrigger = PublishRelay<IamportPayment?>()
        let rightBarButtonItemHiddenTrigger = BehaviorRelay<Bool>(value: false)
        
       Observable.just(())
            .withLatestFrom(postRelay)
            .bind { post in
                guard let post else { return }
                if post.post.creator.userId == UserDefaults.standard.userId {
                    rightBarButtonItemHiddenTrigger.accept(true)
                } else {
                    rightBarButtonItemHiddenTrigger.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.rightBarButtonItem
            .bind(with: self) { owner, _  in
                let payment = IamportPayment(
                    pg: PG.html5_inicis.makePgRawName(pgId: APIKeys.KGINICISId),
                    merchant_uid: "ios_\(APIKeys.sesacKey)_\(Int(Date().timeIntervalSince1970))",
                    amount: "1").then {
                        $0.pay_method = PayMethod.card.rawValue
                        $0.name = "잭님의 사투리교실"
                        $0.buyer_name = APIKeys.buyerName
                        $0.app_scheme = APIKeys.appScheme
                    }
                gotoPaymentPageTrigger.accept(payment)
            }
            .disposed(by: disposeBag)
        
        input.paymentResponse
            .withLatestFrom(postRelay) { paymentResponse, post in
                return ValidatePaymentBody(
                    imp_uid: paymentResponse.imp_uid ?? "",
                    post_id: post?.post.postId ?? "",
                    productName: "잭님의 사투리교실", // TODO: - post title로 변경하기
                    price: 1
                )
            }
            .flatMap {
                return PaymentManager.validatePayment(body: $0)
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<ValidatePaymentModel>.never()
                    }
            }
            .subscribe { validatedPayment in
                print("결제 영수증 검증 완료!!")
                print("validatedPayment", validatedPayment)
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
                .catch { error in
                    print(error.errorCode, error.errorDesc)
                    return Single<String>.never()
                }
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
            .map { post in
                if !UserDefaults.standard.followings.contains(where: { $0.userId == post.creator.userId }) {
                    let newFollowing = Following(
                        userId: post.creator.userId,
                        nick: post.creator.nick,
                        profileImage: post.creator.profileImage
                    )
                    UserDefaults.standard.followings.append(newFollowing)
                }
                return post
            }
            .flatMap {
                return FollowManager.follow(params: FollowParams(userId: $0.creator.userId))
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<String>.never()
                    }
            }
            .subscribe(with: self) { owner, _ in
                owner.followButtonTapTriggerRelay.accept(true)
            }
            .disposed(by: disposeBag)
        
        unFollowTrigger
            .flatMap {
                return FollowManager.unfollow(params: UnFollowParams(userId: $0.creator.userId))
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<String>.never()
                    }
            }
            .subscribe(with: self) { owner, unfollowedUserId in
                UserDefaults.standard.followings.removeAll(where: { $0.userId == unfollowedUserId })
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
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<Post>.never()
                    }
            }
            .subscribe { itemTapTrigger.accept($0) }
            .disposed(by: disposeBag)
        
        let moveToOtherProfileTrigger = profileImageViewTapTapSubject
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
        
        return Output(
            rightBarButtonItemHiddenTrigger: rightBarButtonItemHiddenTrigger.asDriver(),
            sections: sectionsRelay.asDriver(onErrorJustReturn: []),
            post: postRelay.asDriver(),
            postId: postIdRelay.asDriver(onErrorJustReturn: ""),
            mapViewTapTrigger: mapViewTapRelay.asDriver(onErrorJustReturn: CLLocationCoordinate2D()),
            itemTapTrigger: itemTapTrigger.asDriver(onErrorJustReturn: nil),
            moveToOtherProfileTrigger: moveToOtherProfileTrigger.asDriver(onErrorJustReturn: ""), 
            gotoPaymentPageTrigger: gotoPaymentPageTrigger.asDriver(onErrorJustReturn: nil)
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
