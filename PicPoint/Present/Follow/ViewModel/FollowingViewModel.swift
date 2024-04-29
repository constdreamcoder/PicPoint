//
//  FollowingViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/29/24.
//

import Foundation
import RxSwift
import RxCocoa

final class FollowingViewModel: ViewModelType {
    var disposeBag = DisposeBag()

    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        Output()
    }
    
}

extension FollowingViewModel: FollowViewModelForFollowingsDelegate {
    func sendFollowingsData(_ followings: [Following]) {
        print("followings", followings)
    }
}
