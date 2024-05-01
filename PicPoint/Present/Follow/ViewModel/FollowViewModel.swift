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
    func sendFollowingsData(_ followings: [Following])
}

final class FollowViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
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
    
    func transform(input: Input) -> Output {
        
        input.viewWillAppear
            .bind(with: self) { owner, _ in
                let userDefaults = UserDefaults.standard
                owner.followersSubject.onNext(userDefaults.followers)
                owner.followingsSubject.onNext(userDefaults.followings)
                owner.followingsCountRelay.accept(userDefaults.followings.count)
            }
            .disposed(by: disposeBag)
        
        let followersCount = followersSubject
            .withUnretained(self)
            .map { owner, followers in
                owner.delegateForFollower?.sendFollowersData(followers)
                return followers.count
            }
        
        followingsSubject
            .subscribe(with: self) { owner , followings in
                owner.delegateForFollowing?.sendFollowingsData(followings)
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
                
        Observable<Int>.just(followingsCount)
            .subscribe(with: self) { owner, followingsCount in
                owner.followingsCountRelay.accept(followingsCount)
            }
            .disposed(by: disposeBag)
    }
}
