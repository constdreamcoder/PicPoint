//
//  NicknameViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class NicknameViewModel: ViewModelType {
    var disposeBag = DisposeBag()

    struct Input {
        let nicknameText: Observable<String>
        let bottomButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let nicknameValid: Driver<Bool>
        let bottomButtonTapTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        let nicknameValidation = input.nicknameText
            .map {
                if $0.count >= 5 {
                    SignUpStorage.shared.nickname = $0.trimmingCharacters(in: .whitespacesAndNewlines)
                    return true
                } else {
                    return false
                }
            }
        
        let bottomButtonTapTrigger = input.bottomButtonTap
        
        return Output(
            nicknameValid: nicknameValidation.asDriver(onErrorJustReturn: false),
            bottomButtonTapTrigger: bottomButtonTapTrigger.asDriver()
        )
    }
}
