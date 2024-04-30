//
//  FollowerViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/29/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FollowerViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    private let followersRelay = BehaviorRelay<[Follower]>(value: [])

    struct Input {
        
    }
    
    struct Output {
        let followers: Driver<[Follower]>
    }
    
    func transform(input: Input) -> Output {
        
        Output(followers: followersRelay.asDriver())
    }
}

extension FollowerViewModel: FollowViewModelForFollowersDelegate {
    func sendFollowersData(_ followers: [Follower]) {
        print("followers", followers)
        
        Observable<[Follower]>.just(followers)
            .subscribe(with: self) { owner, followers in
                owner.followersRelay.accept(followers)
            }
            .disposed(by: disposeBag)
    }
}
