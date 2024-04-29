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
    

    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        Output()
    }
}

extension FollowerViewModel: FollowViewModelForFollowersDelegate {
    func sendFollowersData(_ followers: [Follower]) {
        print("followers", followers)
    }
}
