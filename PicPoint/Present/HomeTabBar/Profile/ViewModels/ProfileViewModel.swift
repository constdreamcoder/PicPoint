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
    
    let editProfileButtonTap = PublishRelay<Void>()
    let segmentControlSelectedIndexRelay = BehaviorRelay<Int>(value: 0)
    let myProfile = BehaviorRelay<FetchMyProfileModel?>(value: nil)
    let myPosts = BehaviorRelay<[String]>(value: [])
    let moveToFollowTap = PublishSubject<Void>()
    let updateFollowingsCountRelay = PublishRelay<Int>()
    private let updateContentSizeRelay = PublishRelay<CGFloat>()
    
    weak var delegate: ProfileViewModelDelegate?

    struct Input {
        let viewDidLoad: Observable<Void>
        let viewWillAppear: Observable<Bool>
    }
    
    struct Output {
        let sections: Driver<[SectionModelWrapper]>
        let updateContentSize: Driver<CGFloat>
        let editProfileButtonTapTrigger: Driver<FetchMyProfileModel?>
        let moveToFollowTapTrigger: Driver<Void>
        let userNickname: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let sections: [SectionModelWrapper] = [
            SectionModelWrapper(
                ProfileCollectionViewFirstSectionDataModel(
                    items: ["fgdsfg"] // TODO: - 열거형으로 빼기
                )
            ),
            SectionModelWrapper(
                ProfileCollectionViewSecondSectionDataModel(
                    items: ["1"] // TODO: - 열거형으로 빼기
                )
            )
        ]
        
        let sectionsObservable = Observable<[SectionModelWrapper]>.just(sections)
        
        input.viewDidLoad
            .flatMap { _ in
                ProfileManager.fetchMyProfile()
            }
            .subscribe(with: self) { owner, myProfileModel in
                owner.myProfile.accept(myProfileModel)
                owner.myPosts.accept(myProfileModel.posts)
                owner.delegate?.sendMyPosts(myProfileModel.posts)
            }
            .disposed(by: disposeBag)
        
        input.viewWillAppear
            .subscribe(with: self) { owner, _ in
                owner.updateFollowingsCountRelay.accept(UserDefaults.standard.followings.count)
            }
            .disposed(by: disposeBag)
        
        let editProfileButtonTapTrigger = editProfileButtonTap
            .withLatestFrom(myProfile)
                
        let userNickname = myProfile
            .map { fetchMyProfileModel in
                guard let fetchMyProfileModel else { return "" }
                return fetchMyProfileModel.nick
            }
        
        return Output(
            sections: sectionsObservable.asDriver(onErrorJustReturn: []),
            updateContentSize: updateContentSizeRelay.asDriver(onErrorJustReturn: 0),
            editProfileButtonTapTrigger: editProfileButtonTapTrigger.asDriver(onErrorJustReturn: nil),
            moveToFollowTapTrigger: moveToFollowTap.asDriver(onErrorJustReturn: ()),
            userNickname: userNickname.asDriver(onErrorJustReturn: "")
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
    
}

extension ProfileViewModel: MyLikeViewModelDelegate {
    func sendMyLikeCollectionViewContentHeight(_ contentHeight: CGFloat) {
        Observable.just(contentHeight)
            .subscribe(with: self) { owner, contentHeight in
                owner.updateContentSizeRelay.accept(contentHeight)
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
