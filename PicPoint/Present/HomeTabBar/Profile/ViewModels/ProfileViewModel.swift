//
//  ProfileViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/15/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol ProfileViewModelDelegate: AnyObject {
    func sendMyPosts(_ posts: [String])
}

final class ProfileViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    let editProfileButtonTap = PublishRelay<CustomProfileButton.ProfileImageType>()
    let segmentControlSelectedIndexRelay = BehaviorRelay<Int>(value: 0)
    let myProfile = BehaviorRelay<FetchMyProfileModel?>(value: nil)
    let myPosts = BehaviorRelay<[String]>(value: [])
    let moveToFollowTap = PublishSubject<Void>()
    let updateFollowingsCountRelay = PublishRelay<Int>()
    
    private let updateContentSizeRelay = PublishRelay<CGFloat>()
    private let userIdSubject = BehaviorSubject<String>(value: "")
    private let postForMovingToDetailVCRelay = PublishRelay<Post?>()
    
    weak var delegate: ProfileViewModelDelegate?
    
    struct Input {
        let viewWillAppear: Observable<Bool>
        let refreshControlValueChanged: ControlEvent<Void>
        let goToMapButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let sections: Driver<[SectionModelWrapper]>
        let updateContentSize: Driver<CGFloat>
        let editProfileButtonTapTrigger: Driver<FetchMyProfileModel?>
        let moveToFollowTapTrigger: Driver<FetchMyProfileModel?>
        let myProfile: Driver<FetchMyProfileModel?>
        let moveToDetailVCTrigger: Driver<Post?>
        let endRefreshTrigger: Driver<Void>
    }
    
    init(_ userId: String = "") {
        Observable<String>.just(userId)
            .subscribe(with: self) { owner, userId in
                print("userId", userId)
                owner.userIdSubject.onNext(userId)
            }
            .disposed(by: disposeBag)
    }
    
    func transform(input: Input) -> Output {
        let otherProfileTrigger = PublishSubject<String>()
        let myProfileTrigger = PublishSubject<Void>()
        let editMyProfileTrigger = PublishRelay<FetchMyProfileModel?>()
        let followTrigger = PublishSubject<FetchMyProfileModel>()
        let unFollowTrigger = PublishSubject<FetchMyProfileModel>()
        let endRefreshTrigger = PublishRelay<Void>()
        
        let sections: [SectionModelWrapper] = [
            SectionModelWrapper(
                ProfileCollectionViewFirstSectionDataModel(
                    items: ["ProfileSection"] // TODO: - 열거형으로 빼기
                )
            ),
            SectionModelWrapper(
                ProfileCollectionViewSecondSectionDataModel(
                    items: ["ContentsSection"] // TODO: - 열거형으로 빼기
                )
            )
        ]
        
        let sectionsObservable = Observable<[SectionModelWrapper]>.just(sections)
        
        otherProfileTrigger
            .flatMap {
                ProfileManager.fetchOtherProfile(params: FetchOtherProfileParams(userId: $0))
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<FetchOtherProfileModel>.never()
                    }
            }
            .map { otherProfile in
                return FetchMyProfileModel(
                    userId: otherProfile.userId,
                    email: "",
                    nick: otherProfile.nick,
                    profileImage: otherProfile.profileImage,
                    birthDay: "",
                    phoneNum: "",
                    followers: otherProfile.followers,
                    followings: otherProfile.following,
                    posts: otherProfile.posts
                )
            }
            .subscribe(with: self) { owner, otherProfile in
                owner.myProfile.accept(otherProfile)
                owner.myPosts.accept(otherProfile.posts)
                owner.delegate?.sendMyPosts(otherProfile.posts)
                endRefreshTrigger.accept(())
            }
            .disposed(by: disposeBag)
            
        myProfileTrigger
            .flatMap { _ in
                ProfileManager.fetchMyProfile()
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<FetchMyProfileModel>.never()
                    }
            }
            .subscribe(with: self) { owner, myProfileModel in
                owner.myProfile.accept(myProfileModel)
                owner.myPosts.accept(myProfileModel.posts)
                owner.delegate?.sendMyPosts(myProfileModel.posts)
                endRefreshTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        userIdSubject
            .subscribe { userId  in
                if userId != "" && UserDefaults.standard.userId != userId {
                    otherProfileTrigger.onNext(userId)
                } else {
                    myProfileTrigger.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        input.refreshControlValueChanged
            .withLatestFrom(userIdSubject)
            .bind { userId  in
                if userId != "" && UserDefaults.standard.userId != userId {
                    otherProfileTrigger.onNext(userId)
                } else {
                    myProfileTrigger.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .withLatestFrom(userIdSubject)
            .subscribe(with: self) { owner, userId in
                if userId == "" || userId == UserDefaults.standard.userId {
                    owner.updateFollowingsCountRelay.accept(UserDefaults.standard.followings.count)
                }
            }
            .disposed(by: disposeBag)
        
        followTrigger
            .map { fetchMyProfileModel in
                if !UserDefaults.standard.followings.contains(where: { $0.userId == fetchMyProfileModel.userId }) {
                    let newFollowing = Following(
                        userId: fetchMyProfileModel.userId,
                        nick: fetchMyProfileModel.nick,
                        profileImage: fetchMyProfileModel.profileImage
                    )
                    UserDefaults.standard.followings.append(newFollowing)
                }
                return fetchMyProfileModel
            }
            .flatMap {
                return FollowManager.follow(params: FollowParams(userId: $0.userId))
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<String>.never()
                    }
            }
            .subscribe(with: self) { owner, followedUserId in
                otherProfileTrigger.onNext(followedUserId)
            }
            .disposed(by: disposeBag)
        
        unFollowTrigger
            .flatMap {
                return FollowManager.unfollow(params: UnFollowParams(userId: $0.userId))
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<String>.never()
                    }
            }
            .subscribe(with: self) { owner, unfollowedUserId in
                UserDefaults.standard.followings.removeAll(where: { $0.userId == unfollowedUserId })
                otherProfileTrigger.onNext(unfollowedUserId)
            }
            .disposed(by: disposeBag)
                
        editProfileButtonTap
            .withLatestFrom(myProfile) { ($0, $1) }
            .bind { profileImageType, myProfile in
                switch profileImageType {
                case .myProfile:
                    editMyProfileTrigger.accept(myProfile)
                case .following:
                    guard let myProfile else { return }
                    unFollowTrigger.onNext(myProfile)
                case .unfollowing:
                    guard let myProfile else { return }
                    followTrigger.onNext(myProfile)
                }
            }
            .disposed(by: disposeBag)
        
        let moveToFollowTapTrigger = moveToFollowTap
            .withLatestFrom(myProfile)
        
        input.goToMapButtonTapped
            .bind { _ in
                print("눌림")
            }
            .disposed(by: disposeBag)
            
        return Output(
            sections: sectionsObservable.asDriver(onErrorJustReturn: []),
            updateContentSize: updateContentSizeRelay.asDriver(onErrorJustReturn: 0),
            editProfileButtonTapTrigger: editMyProfileTrigger.asDriver(onErrorJustReturn: nil),
            moveToFollowTapTrigger: moveToFollowTapTrigger.asDriver(onErrorJustReturn: nil),
            myProfile: myProfile.asDriver(onErrorJustReturn: nil),
            moveToDetailVCTrigger: postForMovingToDetailVCRelay.asDriver(onErrorJustReturn: nil),
            endRefreshTrigger: endRefreshTrigger.asDriver(onErrorJustReturn: ())
        )
    }
}

extension ProfileViewModel: MyPostViewModelDelegate {
    func sendMyPostCollectionViewContentHeight(_ contentHeight: CGFloat) {
        Observable.just(contentHeight)
            .subscribe(with: self) { owner, contentHeight in
                owner.updateContentSizeRelay.accept(contentHeight)
            }
            .disposed(by: disposeBag)
    }
    
    func sendNewPostId(_ postId: String) {
        Observable<String>.just(postId)
            .withLatestFrom(myPosts)
            .subscribe(with: self) { owner, myPosts in
                owner.myPosts.accept(myPosts + [postId])
            }
            .disposed(by: disposeBag)
    }
    
    func sendUpdatedPostIdList(_ postIdList: [String]) {
        Observable<[String]>.just(postIdList)
            .subscribe(with: self) { owner, postIdList in
                owner.myPosts.accept(postIdList)
            }
            .disposed(by: disposeBag)
    }
    
    func sendPostForMovingToDetailVCFromMyPostVC(_ post: Post) {
        Observable<Post>.just(post)
            .subscribe(with: self) { owner, post in
                owner.postForMovingToDetailVCRelay.accept(post)
            }
            .disposed(by: disposeBag)
    }
}

extension ProfileViewModel: MyLikeViewModelDelegate {
    func sendMyLikeCollectionViewContentHeight(_ contentHeight: CGFloat) {
        Observable.just(contentHeight)
            .subscribe(with: self) { owner, contentHeight in
                owner.updateContentSizeRelay.accept(contentHeight)
            }
            .disposed(by: disposeBag)
    }
    
    func sendPostForMovingToDetailVCFromMyLikeVC(_ post: Post) {
        Observable<Post>.just(post)
            .subscribe(with: self) { owner, post in
                owner.postForMovingToDetailVCRelay.accept(post)
            }
            .disposed(by: disposeBag)
    }
}

extension ProfileViewModel: EditViewModelDelegate {
    func sendUpdatedProfileInfos(_ myNewProfile: FetchMyProfileModel) {
        Observable.just(myNewProfile)
            .subscribe(with: self) { owner, newMyProfile in
                owner.myProfile.accept(newMyProfile)
            }
            .disposed(by: disposeBag)
    }
}
