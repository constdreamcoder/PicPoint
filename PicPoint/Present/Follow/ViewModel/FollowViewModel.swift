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
    
    let followersSubject = BehaviorSubject<[Follower]>(value: [])
    let followingsSubject = BehaviorSubject<[Following]>(value: [])
    
    weak var delegateForFollower: FollowViewModelForFollowersDelegate?
    weak var delegateForFollowing: FollowViewModelForFollowingsDelegate?
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    init(myProfile: FetchMyProfileModel) {
        Observable<FetchMyProfileModel>.just(myProfile)
            .subscribe(with: self) { owner, myProfile in
                owner.followersSubject.onNext(myProfile.followers)
                owner.followingsSubject.onNext(myProfile.followings)
               
            }
            .disposed(by: disposeBag)
    }
    
    func transform(input: Input) -> Output {
        
        followersSubject
            .subscribe(with: self) { owner, followers in
                owner.delegateForFollower?.sendFollowersData(followers)
            }
            .disposed(by: disposeBag)
        
        followingsSubject
            .subscribe(with: self) { owner, followings in
                owner.delegateForFollowing?.sendFollowingsData(followings)
            }
            .disposed(by: disposeBag)
    
        return Output()
    }
    
}
