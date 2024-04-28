//
//  BirthDaySignUpViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class BirthDaySignUpViewModel: ViewModelType {
    var disposeBag = DisposeBag()

    struct Input {
        let bottomButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let bottomButtonTapTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let bottomButtonTapTrigger = input.bottomButtonTap
            
        
        return Output(
            bottomButtonTapTrigger: bottomButtonTapTrigger.asDriver()
        )
    }
}
