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
                UserDefaults.standard.userId = loginModel.userId
                UserDefaults.standard.email = loginModel.email
                UserDefaults.standard.nick = loginModel.nick
                UserDefaults.standard.accessToken = loginModel.accessToken
                UserDefaults.standard.refreshToken = loginModel.refreshToken
                
                let accessTokenDueDate = Date().addingTimeInterval(120 * 60) 
//                let testAccessTokenDueDate = Date().addingTimeInterval(1 * 60)
                UserDefaults.standard.accessTokenDueDate = accessTokenDueDate
                let refreshTokenDueDate = Date().addingTimeInterval(1200 * 60)
//                let testRefreshTokenDueDate = Date().addingTimeInterval(5 * 60)
                UserDefaults.standard.refreshTokenDueDate = refreshTokenDueDate
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
