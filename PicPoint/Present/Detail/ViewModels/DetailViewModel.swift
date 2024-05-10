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
    private let selectedDonationAmountSubject = BehaviorSubject<Int>(value: 0)
    private let nextCorsorSubject = BehaviorSubject<String?>(value: nil)
    
    weak var delegate: DetailViewModelDelegate?
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let rightBarButtonItem: ControlEvent<Void>
        let heartButtonTap: ControlEvent<Void>
        let commentButtonTap: ControlEvent<Void>
        let itemTap: PublishSubject<Int>
        let paymentResponse: PublishSubject<IamportResponse>
        let refreshControllValueChagned: ControlEvent<Void>
        let prefetchItems: ControlEvent<[IndexPath]>
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
        let endRefreshTrigger: Driver<Void>
        let inputDonationTrigger: Driver<Void>
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
                    limit: "3",
                    hashTag: post.hashTags.count == 0 ? "" : post.hashTags[0]
                )
            }
            .flatMap { fetchPostWithHashTagQuery in
                PostManager.FetchPostWithHashTag(query: fetchPostWithHashTagQuery)
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<PostListModel>.never()
                    }
            }
            .subscribe(with: self) { owner, postListModel in
                owner.nextCorsorSubject.onNext(postListModel.nextCursor)
                let postList = postListModel.data
                
                let separatedLocationStrings = post.content1?.components(separatedBy: "/")
                
                let latitude = Double(separatedLocationStrings?[0] ?? "") ?? 0
                let longitude = Double(separatedLocationStrings?[1] ?? "") ?? 0
                
                let separatedDateStrings = post.content2?.components(separatedBy: "/")
                
                let sections = owner.createSections(
                    post: post,
                    postList: postList,
                    separatedLocationStrings: separatedLocationStrings,
                    latitude: latitude,
                    longitude: longitude,
                    separatedDateStrings: separatedDateStrings)
                
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
        let postRefreshTrigger = PublishSubject<Post>()
        let endRefreshTrigger = PublishRelay<Void>()
        let updateRelatedPostListTrigger = PublishSubject<Void>()
        let updateHashTagSearchKeywordTrigger = PublishSubject<Void>()
        
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
        
        selectedDonationAmountSubject
            .withLatestFrom(postRelay) { (amount: $0, post: $1) }
            .bind(with: self) { owner, value  in
                let payment = IamportPayment(
                    pg: PG.html5_inicis.makePgRawName(pgId: APIKeys.KGINICISId),
                    merchant_uid: "ios_\(APIKeys.sesacKey)_\(Int(Date().timeIntervalSince1970))",
                    amount: "\(value.amount)").then {
                        $0.pay_method = PayMethod.card.rawValue
                        $0.name = value.post?.post.title ?? ""
                        $0.buyer_name = APIKeys.buyerName
                        $0.app_scheme = APIKeys.appScheme
                    }
                gotoPaymentPageTrigger.accept(payment)
            }
            .disposed(by: disposeBag)
        
        postRefreshTrigger
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
                    limit: "3",
                    hashTag: post.hashTags.count == 0 ? "" : post.hashTags[0]
                )
            }
            .flatMap { fetchPostWithHashTagQuery in
                PostManager.FetchPostWithHashTag(query: fetchPostWithHashTagQuery)
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<PostListModel>.never()
                    }
            }
            .withLatestFrom(postRefreshTrigger) { (postListModel: $0, post: $1) }
            .subscribe(with: self) { owner, value in
                owner.nextCorsorSubject.onNext(value.postListModel.nextCursor)
                
                let post = value.post
                let postList = value.postListModel.data
                
                let separatedLocationStrings = post.content1?.components(separatedBy: "/")
                
                let latitude = Double(separatedLocationStrings?[0] ?? "") ?? 0
                let longitude = Double(separatedLocationStrings?[1] ?? "") ?? 0
                
                let separatedDateStrings = post.content2?.components(separatedBy: "/")
                
                let sections = owner.createSections(
                    post: post,
                    postList: postList,
                    separatedLocationStrings: separatedLocationStrings,
                    latitude: latitude,
                    longitude: longitude,
                    separatedDateStrings: separatedDateStrings)
                
                owner.sectionsRelay.accept(sections)
                owner.relatedPostList.onNext(postList.filter { $0.postId != post.postId })
                endRefreshTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        input.refreshControllValueChagned
            .withLatestFrom(postRelay)
            .bind { post in
                guard let post else { return }
                postRefreshTrigger.onNext(post.post)
            }
            .disposed(by: disposeBag)
        
        input.paymentResponse
            .withLatestFrom(selectedDonationAmountSubject) { (paymentResponse: $0, donationAmount: $1) }
            .withLatestFrom(postRelay){ value, post in
                ValidatePaymentBody(
                    imp_uid: value.paymentResponse.imp_uid ?? "",
                    post_id: post?.post.postId ?? "",
                    productName: post?.post.title ?? "",
                    price: value.donationAmount
                )
            }
            .flatMap {
                PaymentManager.validatePayment(body: $0)
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
        
        updateHashTagSearchKeywordTrigger
            .withLatestFrom(hashTagsSubject)
            .bind(with: self) { owner, hashTags in
                guard hashTags.count > 0 else { return }
                var hashTags = hashTags
                hashTags.remove(at: 0)
                owner.hashTagsSubject.onNext(hashTags)
                owner.nextCorsorSubject.onNext(nil)
            }
            .disposed(by: disposeBag)
        
        updateRelatedPostListTrigger
            .withLatestFrom(nextCorsorSubject)
            .withLatestFrom(hashTagsSubject) { (nextCorsor: $0, hashTags: $1) }
            .map{ value in
                return FetchPostWithHashTagQuery(
                    next: value.nextCorsor,
                    limit: "3",
                    hashTag: value.hashTags.count == 0 ? "" : value.hashTags[0]
                )
            }
            .flatMap { fetchPostWithHashTagQuery in
                PostManager.FetchPostWithHashTag(query: fetchPostWithHashTagQuery)
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<PostListModel>.never()
                    }
            }
            .withLatestFrom(relatedPostList) { ($0, $1) }
            .withLatestFrom(postRelay, resultSelector: { value, post in
                (postListModel: value.0, relatedPostList: value.1, post: post)
            })
            .subscribe(with: self) { owner, value in
                owner.nextCorsorSubject.onNext(value.postListModel.nextCursor)
                
                guard let post = value.post?.post else { return }
        
                let separatedLocationStrings = post.content1?.components(separatedBy: "/")

                let latitude = Double(separatedLocationStrings?[0] ?? "") ?? 0
                let longitude = Double(separatedLocationStrings?[1] ?? "") ?? 0
                
                let separatedDateStrings = post.content2?.components(separatedBy: "/")
                
                let newPostList = value.postListModel.data
                let updatedRelatedPostList = value.relatedPostList + newPostList
                owner.relatedPostList.onNext(updatedRelatedPostList)
                
                let sections = owner.createSections(
                    post: post,
                    postList: updatedRelatedPostList,
                    separatedLocationStrings: separatedLocationStrings,
                    latitude: latitude,
                    longitude: longitude,
                    separatedDateStrings: separatedDateStrings)
                
                owner.sectionsRelay.accept(sections)
                
                if Int(value.postListModel.nextCursor ?? "") == 0 {
                    updateHashTagSearchKeywordTrigger.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        input.prefetchItems
            .withLatestFrom(nextCorsorSubject) { ($0, $1) }
            .withLatestFrom(relatedPostList) { value, relatedPostList in
                (indexPaths: value.0, nextCursor: value.1, relatedPostList: relatedPostList)
            }
            .bind { value in
                for indexPath in value.indexPaths {
                    if indexPath.section == 3 {
                        if indexPath.item == value.relatedPostList.count - 2
                            && Int(value.nextCursor ?? "") != 0 {
                            updateRelatedPostListTrigger.onNext(())
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            rightBarButtonItemHiddenTrigger: rightBarButtonItemHiddenTrigger.asDriver(),
            sections: sectionsRelay.asDriver(onErrorJustReturn: []),
            post: postRelay.asDriver(),
            postId: postIdRelay.asDriver(onErrorJustReturn: ""),
            mapViewTapTrigger: mapViewTapRelay.asDriver(onErrorJustReturn: CLLocationCoordinate2D()),
            itemTapTrigger: itemTapTrigger.asDriver(onErrorJustReturn: nil),
            moveToOtherProfileTrigger: moveToOtherProfileTrigger.asDriver(onErrorJustReturn: ""), 
            gotoPaymentPageTrigger: gotoPaymentPageTrigger.asDriver(onErrorJustReturn: nil), 
            endRefreshTrigger: endRefreshTrigger.asDriver(onErrorJustReturn: ()),
            inputDonationTrigger: input.rightBarButtonItem.asDriver()
        )
    }
}

extension DetailViewModel {
    private func createSections(
        post: Post,
        postList: [Post],
        separatedLocationStrings: [String]?,
        latitude: Double,
        longitude: Double,
        separatedDateStrings: [String]?
    ) -> [SectionModelWrapper] {
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
        
        return sections
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

extension DetailViewModel: InputDonationViewModelDelegate {
    func sendSelectedDonationAmount(_ amount: Int) {
        Observable.just(amount)
            .subscribe(with: self) { owner, amount in
                owner.selectedDonationAmountSubject.onNext(amount)
            }
            .disposed(by: disposeBag)
    }
}
