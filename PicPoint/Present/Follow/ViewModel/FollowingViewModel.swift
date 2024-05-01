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
                UserDefaults.standard.followings.append(following)
                return following
            }
            .flatMap {
                FollowManager.follow(params: FollowParams(userId: $0.userId))
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
            .subscribe(with: self) { owner, updatedFollowings in
                owner.followingsRelay.accept(updatedFollowings)
                
                let followingsCount = UserDefaults.standard.followings.count
                owner.delegate?.sendUpdatedFollowingsCount(followingsCount)
            }
            .disposed(by: disposeBag)
        
        unFollowTrigger
            .flatMap {
                FollowManager.unfollow(params: UnFollowParams(userId: $0.userId))
            }
            .withLatestFrom(followingsRelay) { unFollowedUserId, followings -> [FollowingCellType] in
                UserDefaults.standard.followings.removeAll(where: { $0.userId == unFollowedUserId })
                return followings.map { following in
                    if following.following.userId == unFollowedUserId {
                        return (following.following, .unfollowing)
                    } else {
                        return following
                    }
                }
            }
            .subscribe(with: self) { owner, updatedFollowings in
                owner.followingsRelay.accept(updatedFollowings)
                
                let followingsCount = UserDefaults.standard.followings.count
                owner.delegate?.sendUpdatedFollowingsCount(followingsCount)
            }
            .disposed(by: disposeBag)
            
        selectedFollowingSubject
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { following, followType in
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
    
    func sendFollowingsData(_ followings: [Following]) {
        
        Observable<[Following]>.just(followings)
            .map { followings -> [FollowingCellType] in
                followings.map { following in
                    return (following, .following)
                }
            }
            .subscribe(with: self) { owner, followings in
                owner.followingsRelay.accept(followings)
            }
            .disposed(by: disposeBag)
    }
}
