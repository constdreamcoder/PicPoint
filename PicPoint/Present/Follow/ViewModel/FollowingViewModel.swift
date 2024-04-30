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

typealias FollowingCellType = (following: Following, followingStatus: Bool)

final class FollowingViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    weak var delegate: FollowingViewModelDelegate?
    
    let followButtonTapTriggerRelay = PublishRelay<Bool>()
    let selectedFollowingSubject = PublishSubject<Following>()
    let selectedFollowingFollowTypeSubject = PublishSubject<CustomButtonWithFollowType.FollowType>()
    
    private let followingsSubject = BehaviorSubject<[Following]>(value: [])
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
            .flatMap {
                UserDefaults.standard.followings.append($0)
                return FollowManager.follow(params: FollowParams(userId: $0.userId))
            }
            .subscribe(with: self) { owner, followModel in
                print("followings", UserDefaults.standard.followings)
                owner.followButtonTapTriggerRelay.accept(followModel.followingStatus)
                owner.delegate?.sendUpdatedFollowingsCount(UserDefaults.standard.followings.count)
            }
            .disposed(by: disposeBag)
        
        unFollowTrigger
            .flatMap { following in
                UserDefaults.standard.followings.removeAll(where: { $0.userId == following.userId })
                return FollowManager.unfollow(params: UnFollowParams(userId: following.userId))
            }
            .subscribe(with: self) { owner, followModel in
                print("followings", UserDefaults.standard.followings)
                owner.followButtonTapTriggerRelay.accept(followModel.followingStatus)
                owner.delegate?.sendUpdatedFollowingsCount(UserDefaults.standard.followings.count)
            }
            .disposed(by: disposeBag)
            
        selectedFollowingSubject
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(selectedFollowingFollowTypeSubject) { ($0, $1)}
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
                
        let followings = followingsSubject
            .map { followings -> [FollowingCellType] in
                followings.map { following in
                    if UserDefaults.standard.followers.contains(where: { $0.userId == following.userId }) {
                        return (following, true)
                    } else {
                        return (following, true)
                    }
                }
            }
        
        return Output(
            followings: followings.asDriver(onErrorJustReturn: [])
        )
    }
    
}

extension FollowingViewModel: FollowViewModelForFollowingsDelegate {
    
    func sendFollowingsData(_ followings: [Following]) {
        
        Observable<[Following]>.just(followings)
            .subscribe(with: self) { owner, followings in
                owner.followingsSubject.onNext(followings)
            }
            .disposed(by: disposeBag)
    }
}
