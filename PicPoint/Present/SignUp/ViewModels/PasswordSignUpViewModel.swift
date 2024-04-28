//
//  PasswordSignUpViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/28/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PasswordSignUpViewModel: ViewModelType {
    
    enum PasswordValidationError: Error {
        case lengthError
        case characterError
        case digitError
        case specialCharacterError
        
        var errorMessage: String {
            switch self {
            case .lengthError:
                return "비밀번호는 8자 이상, 15자 이하여야 합니다."
            case .characterError:
                return "비밀번호에는 영문자가 포함되어야 합니다."
            case .digitError:
                return "비밀번호에는 숫자가 포함되어야 합니다."
            case .specialCharacterError:
                return "비밀번호에는 특수문자($@$!%*?&)가 포함되어야 합니다."
            }
        }
    }
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let passwordText: ControlProperty<String>
        let passwordConfirmText: ControlProperty<String>
        let bottomButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let passwordValidation: Driver<String>
        let passwordConfirmValid: Driver<String>
        let bottomButtonValid: Driver<Bool>
        let bottomButtonTapTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let passwordValidation = BehaviorRelay<String>(value: "")
        let passwordConfirmValidation = BehaviorRelay<String>(value: "")
        
        input.passwordText
            .withUnretained(self)
            .flatMap { owner, passwordText in
                owner.validatePassword(passwordText.trimmingCharacters(in: .whitespaces))
            }
            .subscribe {
                passwordValidation.accept($0)
            }
            .disposed(by: disposeBag)
        
        input.passwordConfirmText
            .withLatestFrom(input.passwordText) { 
                if $0 == $1 {
                    SignUpStorage.shared.password = $0.trimmingCharacters(in: .whitespacesAndNewlines)
                    return "200"
                } else {
                    return "비밀번호가 일치하지 않습니다"
                }
            }
            .subscribe {
                passwordConfirmValidation.accept($0)
            }
            .disposed(by: disposeBag)
        
        let bottomButtonValidation = Observable.combineLatest(
            passwordValidation,
            passwordConfirmValidation
        )
            .map {
                Int($0) == 200 && Int($1) == 200 ? true : false
            }
            
        let bottomButtonTapTrigger = input.bottomButtonTap
        
        return Output(
            passwordValidation: passwordValidation.asDriver(onErrorJustReturn: ""),
            passwordConfirmValid: passwordConfirmValidation.asDriver(onErrorJustReturn: ""),
            bottomButtonValid: bottomButtonValidation.asDriver(onErrorJustReturn: false),
            bottomButtonTapTrigger: bottomButtonTapTrigger.asDriver()
        )
    }
}

extension PasswordSignUpViewModel {
    func isValidPassword(_ password: String) -> Bool {
        // 비밀번호가 최소 8자 이상, 15자 이하, 문자, 숫자, 특수문자를 모두 포함하는지를 검사하는 정규식
        let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,15}$"
        
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
        return passwordPredicate.evaluate(with: password)
    }
    
    func validatePassword(_ password: String) -> Single<String> {
        return Single<String>.create { singleObserver in
            
            // 비밀번호가 최소 8자 이상, 15자 이하인지 확인
            guard password.count >= 8 && password.count <= 15 else {
                singleObserver(.success(PasswordValidationError.lengthError.errorMessage))
                return Disposables.create()
            }
            
            // 비밀번호에 영문자가 포함되어 있는지 확인
            guard password.rangeOfCharacter(from: .letters) != nil else {
                singleObserver(.success(PasswordValidationError.characterError.errorMessage))
                return Disposables.create()
            }
            
            // 비밀번호에 숫자가 포함되어 있는지 확인
            guard password.rangeOfCharacter(from: .decimalDigits) != nil else {
                singleObserver(.success(PasswordValidationError.digitError.errorMessage))
                return Disposables.create()
            }
            
            // 비밀번호에 특수문자가 포함되어 있는지 확인
            let specialCharacters = CharacterSet(charactersIn: "$@$!%*?&")
            guard password.rangeOfCharacter(from: specialCharacters) != nil else {
                singleObserver(.success(PasswordValidationError.specialCharacterError.errorMessage))
                return Disposables.create()
            }
            
            // 모든 조건을 만족하면 유효한 비밀번호로 간주
            singleObserver(.success("200"))
            return Disposables.create()
        }
    }
    
    func isValidPasswordConfirm(_ passwordConfirmText: String, with passwordText: String) -> Bool {
        return passwordConfirmText == passwordText ? true : false
    }
    
}
