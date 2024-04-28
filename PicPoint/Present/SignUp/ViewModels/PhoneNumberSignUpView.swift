//
//  PhoneNumberSignUpViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PhoneNumberSignUpViewModel: ViewModelType {
    var disposeBag = DisposeBag()

    struct Input {
        let phoneNumberText: Observable<String>
        let bottomButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let bottomButtonTapTrigger: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        
        let bottomButtonTapTrigger = input.bottomButtonTap
            .withLatestFrom(input.phoneNumberText)
            .withUnretained(self)
            .map { owner, phoneNumberText in
                if phoneNumberText == "" || owner.isValidPhoneNumber(phoneNumberText) {
                    SignUpStorage.shared.phoneNumber = phoneNumberText
                    return true
                } else {
                    return false
                }
            }
        
        return Output(
            bottomButtonTapTrigger: bottomButtonTapTrigger.asDriver(onErrorJustReturn: false)
        )
    }
}

extension PhoneNumberSignUpViewModel {
    func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        // 전화번호가 숫자로만 이루어져 있는지 확인
        guard let _ = Int(phoneNumber) else {
            return false
        }

        // 전화번호의 길이가 유효한지 확인
        let validLengths = [10, 11]
        guard validLengths.contains(phoneNumber.count) else {
            return false
        }

        // 전화번호의 첫 글자가 0 또는 1로 시작하는지 확인
        guard ["0", "1"].contains(phoneNumber.first.map(String.init)) else {
            return false
        }

        return true
    }
}

