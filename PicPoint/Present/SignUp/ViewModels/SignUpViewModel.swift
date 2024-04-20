//
//  SignUpViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/14/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SignUpViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let emailText: ControlProperty<String>
        let passwordText: ControlProperty<String>
        let nickText: ControlProperty<String>
        let phoneNumText: ControlProperty<String?>
        let birthDayText: ControlProperty<String?>
        let signUpButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let signUpValidation: Driver<Bool>
        let signUpSuccessTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let signUpValid = BehaviorRelay(value: false)
        let signUpSuccessTrigger = PublishRelay<Void>()
        
        let signUpObservable = Observable.combineLatest(
            input.emailText,
            input.passwordText,
            input.nickText,
            input.phoneNumText,
            input.birthDayText
        ).map { emailText, passwordText, nickText, phoneNumText, birthDayText in
            return SignUpBody(
                email: emailText,
                password: passwordText,
                nick: nickText,
                phoneNum: phoneNumText,
                birthDay: birthDayText
            )
        }
        
        signUpObservable
            .bind(with: self) { owner, signUpQuery in
                if signUpQuery.email.contains("@")
                    && signUpQuery.email.contains(".com")
                    && !signUpQuery.password.isEmpty
                    && !signUpQuery.nick.isEmpty {
                    signUpValid.accept(true)
                } else {
                    signUpValid.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.signUpButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(signUpObservable)
            .flatMap{ signUpQuery in
                UserManager.signUp(body: signUpQuery)
            }
            .subscribe(with: self) { owner, signUpModel in
                print("회원가입 완료")
                signUpSuccessTrigger.accept(())
            } onError: { owner, error in
                print("회원가입 오류 발생, \(error)")
            }
            .disposed(by: disposeBag)
        
        return Output(
            signUpValidation: signUpValid.asDriver(),
            signUpSuccessTrigger: signUpSuccessTrigger.asDriver(onErrorJustReturn: ())
        )
    }
}
