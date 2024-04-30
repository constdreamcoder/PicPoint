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

final class DetailViewModel: ViewModelType {
    
    let followButtonTapTriggerRelay = BehaviorRelay<Bool>(value: false)
    let followButtonTapSubject = PublishSubject<CustomButtonWithFollowType.FollowType>()
    let mapViewTapRelay = PublishRelay<CLLocationCoordinate2D>()
    private let sectionsRelay = BehaviorRelay<[SectionModelWrapper]>(value: [])
    private let postRelay = BehaviorRelay<Post?>(value: nil)
    private let hashTagsSubject = BehaviorSubject<[String]>(value: [])
    private let relatedPostList = BehaviorSubject<[Post]>(value: [])
    
    var disposeBag = DisposeBag()

    struct Input {
        let commentButtonTap: ControlEvent<Void>
        let itemTap: PublishSubject<Int>
    }
    
    struct Output {
        let sections: Driver<[SectionModelWrapper]>
        let post: Driver<Post?>
        let postId: Driver<String>
        let mapViewTapTrigger: Driver<CLLocationCoordinate2D>
        let itemTapTrigger: Driver<Post?>
    }
    
    init(post: Post) {
        Observable.just(post)
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
                owner.postRelay.accept(post)
                owner.relatedPostList.onNext(postList)
            }
            .disposed(by: disposeBag)
    }
    
    func transform(input: Input) -> Output {
        let postIdRelay = PublishRelay<String>()
        let itemTapTrigger = PublishRelay<Post?>()
        let followTrigger = PublishSubject<Post>()
        let unFollowTrigger = PublishSubject<Post>()
        
        postRelay
            .bind(with: self) { owner, post in
                if let post {
                    if UserDefaults.standard.followings.contains(where: { $0.userId == post.creator.userId}) {
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
            .subscribe(with: self) { owner, followModel in
                print("followings", UserDefaults.standard.followings)
                owner.followButtonTapTriggerRelay.accept(followModel.followingStatus)
            }
            .disposed(by: disposeBag)
        
        unFollowTrigger
            .flatMap { post in
                UserDefaults.standard.followings.removeAll(where: { $0.userId == post.creator.userId })
                return FollowManager.unfollow(params: UnFollowParams(userId: post.creator.userId))
            }
            .subscribe(with: self) { owner, followModel in
                print("followings", UserDefaults.standard.followings)
                owner.followButtonTapTriggerRelay.accept(followModel.followingStatus)
            }
            .disposed(by: disposeBag)
        
        followButtonTapSubject
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(postRelay) { ($0, $1) }
            .subscribe { followType, post in
                if let post {
                    switch followType {
                    case .following:
                        unFollowTrigger.onNext(post)
                    case .unfollowing:
                        followTrigger.onNext(post)
                    case .none: break
                    }
                }
            }
            .disposed(by: disposeBag)
        
        input.commentButtonTap
            .withLatestFrom(postRelay)
            .subscribe { post in
                guard let post else { return }
                postIdRelay.accept(post.postId)
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

        return Output(
            sections: sectionsRelay.asDriver(onErrorJustReturn: []), 
            post: postRelay.asDriver(), 
            postId: postIdRelay.asDriver(onErrorJustReturn: ""), 
            mapViewTapTrigger: mapViewTapRelay.asDriver(onErrorJustReturn: CLLocationCoordinate2D()),
            itemTapTrigger: itemTapTrigger.asDriver(onErrorJustReturn: nil)
        )
    }
}
