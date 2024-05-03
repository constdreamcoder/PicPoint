//
//  FollowViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/29/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol FollowViewModelForFollowersDelegate: AnyObject {
    func sendFollowersData(_ followers: [Follower])
}

protocol FollowViewModelForFollowingsDelegate: AnyObject {
    func sendFollowingsData(_ followings: [Following], userId: String)
}

final class FollowViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    private let myProfile = BehaviorSubject<FetchMyProfileModel?>(value: nil)
    private let followersSubject = BehaviorSubject<[Follower]>(value: [])
    private let followingsSubject = BehaviorSubject<[Following]>(value: [])
    private let followingsCountRelay = BehaviorRelay<Int>(value: 0)
    
    weak var delegateForFollower: FollowViewModelForFollowersDelegate?
    weak var delegateForFollowing: FollowViewModelForFollowingsDelegate?
    
    struct Input {
        let viewWillAppear: Observable<Bool>
    }
    
    struct Output {
        let followersCount: Driver<Int>
        let followingsCount: Driver<Int>
    }
    
    init(myProfile: FetchMyProfileModel?) {
        guard let myProfile else { return }
        Observable.just(myProfile)
            .subscribe(with: self) { owner, myProfile in
                if myProfile.userId == UserDefaults.standard.userId {
                    let userDefaults = UserDefaults.standard
                    owner.followersSubject.onNext(userDefaults.followers)
                    owner.followingsSubject.onNext(userDefaults.followings)
                    owner.followingsCountRelay.accept(userDefaults.followings.count)
                } else {
                    owner.followersSubject.onNext(myProfile.followers)
                    owner.followingsSubject.onNext(myProfile.followings)
                    owner.followingsCountRelay.accept(myProfile.followings.count)
                }
                owner.myProfile.onNext(myProfile)
            }
            .disposed(by: disposeBag)
    }
    
    func transform(input: Input) -> Output {
        
        input.viewWillAppear
            .withLatestFrom(myProfile)
            .bind(with: self) { owner, myProfile in
                guard let myProfile else { return }
                if UserDefaults.standard.userId == myProfile.userId {
                    let userDefaults = UserDefaults.standard
                    owner.followersSubject.onNext(userDefaults.followers)
                    owner.followingsSubject.onNext(userDefaults.followings)
                    owner.followingsCountRelay.accept(userDefaults.followings.count)
                }
            }
            .disposed(by: disposeBag)
        
        let followersCount = followersSubject
            .withUnretained(self)
            .map { owner, followers in
                owner.delegateForFollower?.sendFollowersData(followers)
                return followers.count
            }
        
        followingsSubject
            .withLatestFrom(myProfile) { ($0, $1?.userId ?? "") }
            .subscribe(with: self) { owner , value in
                owner.delegateForFollowing?.sendFollowingsData(value.0, userId: value.1)
            }
            .disposed(by: disposeBag)
    
        return Output(
            followersCount: followersCount.asDriver(onErrorJustReturn: 0),
            followingsCount: followingsCountRelay.asDriver(onErrorJustReturn: 0)
        )
    }
    
}

extension FollowViewModel: FollowingViewModelDelegate {
    func sendUpdatedFollowingsCount(_ followingsCount: Int) {
        print("count:\(followingsCount)")
        Observable<Int>.just(followingsCount)
            .subscribe(with: self) { owner, followingsCount in
                owner.followingsCountRelay.accept(followingsCount)
                print("send!!")
            }
            .disposed(by: disposeBag)
    }
}
