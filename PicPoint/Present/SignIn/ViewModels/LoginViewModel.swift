//
//  LoginViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/13/24.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel: ViewModelType {
    var disposeBag =  DisposeBag()
    
    struct Input {
        let emailText: ControlProperty<String>
        let passwordText: ControlProperty<String>
        let loginButtonTapped: ControlEvent<Void>
        let goToSignUpButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let loginValidation: Driver<Bool>
        let loginSuccessTrigger: Driver<Void>
        let moveToSignUpVC: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let loginValid = BehaviorRelay(value: false)
        let loginSuccessTrigger = PublishRelay<Void>()
        
        let loginObservable = Observable.combineLatest(
            input.emailText,
            input.passwordText
        ).map { email, password in
            return LoginQuery(email: email, password: password)
        }
        
        loginObservable
            .bind(with: self) { owner, loginQuery in
                if loginQuery.email.contains("@") 
                    && loginQuery.email.contains(".com")
                    && loginQuery.password.count > 3 {
                    loginValid.accept(true)
                } else {
                    loginValid.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        input.loginButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(loginObservable)
            .flatMap { loginQuery in
                return UserManager.login(query: loginQuery)
            }
            .subscribe(with: self) { owner, loginModel in
                UserDefaults.standard.set(loginModel.userId, forKey: "userId")
                UserDefaults.standard.set(loginModel.email, forKey: "email")
                UserDefaults.standard.set(loginModel.nick, forKey: "nick")
                UserDefaults.standard.set(loginModel.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(loginModel.refreshToken, forKey: "refreshToken")
                loginSuccessTrigger.accept(())
            } onError: { owner, error in
                print("로그인 오류 발생, \(error)")
            }
            .disposed(by: disposeBag)
            
        return Output(
            loginValidation: loginValid.asDriver(),
            loginSuccessTrigger: loginSuccessTrigger.asDriver(onErrorJustReturn: ()),
            moveToSignUpVC: input.goToSignUpButtonTapped.asDriver()
        )
    }
    
}
