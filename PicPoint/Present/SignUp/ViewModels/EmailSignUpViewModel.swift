//
//  EmailSignUpViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class EmailSignUpViewModel: ViewModelType {
    var disposeBag = DisposeBag()

    struct Input {
        let emailInputText: Observable<String>
        let bottomButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let emailValidation: Driver<Bool>
        let bottomButtonTapTrigger: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let emailValidation = input.emailInputText
            .withUnretained(self)
            .map { owner, emailInputText in
                if owner.isValidEmail(emailInputText.trimmingCharacters(in: .whitespaces)) {
                    SignUpStorage.shared.email = emailInputText.trimmingCharacters(in: .whitespaces)
                    return true
                } else {
                    return false
                }
            }
        
        let bottomButtonTapTrigger = input.bottomButtonTap
            .withLatestFrom(input.emailInputText)
            .map {
                ValidateEmailBody(email: $0.trimmingCharacters(in: .whitespaces))
            }
            .flatMap { validateEmailBody in
                UserManager.validateEmail(body: validateEmailBody)
            }
            .map { validateEmailModel in
                validateEmailModel.message
            }
            
        return Output(
            emailValidation: emailValidation.asDriver(onErrorJustReturn: false),
            bottomButtonTapTrigger: bottomButtonTapTrigger.asDriver(onErrorJustReturn: "")
        )
    }
}

// MARK: - Custom Methods
extension EmailSignUpViewModel {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}
