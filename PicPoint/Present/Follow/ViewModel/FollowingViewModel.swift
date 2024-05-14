//
//  FollowingViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/29/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol FollowingViewModelDelegate: AnyObject {
    func sendUpdatedFollowingsCount(_ followingsCount: Int)
}

typealias FollowingCellType = (following: Following, followType: FollowType)

final class FollowingViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    weak var delegate: FollowingViewModelDelegate?
    
    let selectedFollowingSubject = PublishSubject<FollowingCellType>()
    
    private let myProfileUserIdRelay = BehaviorRelay<String>(value: "")
    private let followingsRelay = BehaviorRelay<[FollowingCellType]>(value: [])
    private let followersRelay = BehaviorRelay<[Follower]>(value: [])

    struct Input {
        
    }
    
    struct Output {
        let followings: Driver<[FollowingCellType]>
    }
    
    func transform(input: Input) -> Output {
        let followTrigger = PublishSubject<Following>()
        let unFollowTrigger = PublishSubject<Following>()
        
        followTrigger
            .map { following in
                if !UserDefaultsManager.followings.contains(where: { $0.userId == following.userId }) {
                    UserDefaultsManager.followings.append(following)
                }
                return following
            }
            .flatMap {
                FollowManager.follow(params: FollowParams(userId: $0.userId))
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<String>.never()
                    }
            }
            .withLatestFrom(followingsRelay) { followedUserId, followings -> [FollowingCellType] in
                return followings.map { following in
                    if following.following.userId == followedUserId {
                        return (following.following, .following)
                    } else {
                        return following
                    }
                }
            }
            .withLatestFrom(myProfileUserIdRelay) { ($0, $1) }
            .subscribe(with: self) { owner, value in
                owner.followingsRelay.accept(value.0)
                
                let followingsCount = UserDefaultsManager.followings.count
                owner.delegate?.sendUpdatedFollowingsCount(followingsCount)
            }
            .disposed(by: disposeBag)
        
        unFollowTrigger
            .flatMap {
                FollowManager.unfollow(params: UnFollowParams(userId: $0.userId))
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<String>.never()
                    }
            }
            .withLatestFrom(followingsRelay) { unFollowedUserId, followings -> [FollowingCellType] in
                UserDefaultsManager.followings.removeAll(where: { $0.userId == unFollowedUserId })
                return followings.map { following in
                    if following.following.userId == unFollowedUserId {
                        return (following.following, .unfollowing)
                    } else {
                        return following
                    }
                }
            }
            .withLatestFrom(myProfileUserIdRelay) { ($0, $1) }
            .subscribe(with: self) { owner, value in
                owner.followingsRelay.accept(value.0)
                
                let followingsCount = UserDefaultsManager.followings.count
                owner.delegate?.sendUpdatedFollowingsCount(followingsCount)
            }
            .disposed(by: disposeBag)
            
        selectedFollowingSubject
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe { following, followType in
                print(following, followType)
                switch followType {
                case .following:
                    unFollowTrigger.onNext(following)
                case .unfollowing:
                    followTrigger.onNext(following)
                case .none: break
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            followings: followingsRelay.asDriver()
        )
    }
}

extension FollowingViewModel: FollowViewModelForFollowingsDelegate {
    
    func sendFollowingsData(_ followings: [Following], userId: String) {
        
        Observable.just(userId)
            .subscribe(with: self) { owner, userId in
                owner.myProfileUserIdRelay.accept(userId)
            }
            .disposed(by: disposeBag)
        
        Observable<[Following]>.just(followings)
            .map { followings -> [FollowingCellType] in
                return followings.map { following in
                    if UserDefaultsManager.followings.contains(where: {
                        return $0.userId == following.userId
                    }) {
                        return (following, .following)
                    } else {
                        return (following, .unfollowing)
                    }
                }
            }
            .subscribe(with: self) { owner, followings in
                owner.followingsRelay.accept(followings)
            }
            .disposed(by: disposeBag)
    }
}
