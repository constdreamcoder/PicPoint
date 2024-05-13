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
        let emailText: Observable<String>
        let passwordText: ControlProperty<String>
        let loginButtonTapped: ControlEvent<Void>
        let goToSignUpButtonTapped: ControlEvent<Void>
        let showPasswordButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let loginValidation: Driver<Bool>
        let loginSuccessTrigger: Driver<Void>
        let moveToSignUpVC: Driver<Void>
        let loginFailTrigger: Driver<String>
        let showPasswordButtonTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let loginValid = BehaviorRelay<Bool>(value: false)
        let fetchUserProfileTrigger = PublishSubject<Void>()
        let loginSuccessTrigger = PublishRelay<Void>()
        let loginFailTrigger = PublishRelay<String>()
        
        let loginObservable = Observable.combineLatest(
            input.emailText,
            input.passwordText
        ).map { email, password in
            return LoginBody(email: email, password: password)
        }
        
        loginObservable
            .bind(with: self) { owner, loginBody in
                if loginBody.email.contains("@") 
                    && loginBody.email.contains(".com")
                    && loginBody.password.count > 3 {
                    loginValid.accept(true)
                } else {
                    loginValid.accept(false)
                }
            }
            .disposed(by: disposeBag)
        
        fetchUserProfileTrigger
            .flatMap {
                ProfileManager.fetchMyProfile()
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<FetchMyProfileModel>.never()
                    }
            }
            .subscribe { fetchMyProfileModel in
                UserDefaults.standard.followers = fetchMyProfileModel.followers
                UserDefaults.standard.followings = fetchMyProfileModel.followings
                loginSuccessTrigger.accept(())
            }
            .disposed(by: disposeBag)
        
        input.loginButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(loginObservable)
            .flatMap {
                UserManager.login(body: $0)
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        if error.errorCode == 401 {
                            loginFailTrigger.accept(error.errorDesc)
                        }
                        return Single<LoginModel>.never()
                    }
            }
            .subscribe(with: self) { owner, loginModel in
                UserDefaults.standard.userId = loginModel.userId
                UserDefaults.standard.email = loginModel.email
                UserDefaults.standard.nick = loginModel.nick
                UserDefaults.standard.accessToken = loginModel.accessToken
                UserDefaults.standard.refreshToken = loginModel.refreshToken
                
                let accessTokenDueDate = Date().addingTimeInterval(120 * 60) 
                UserDefaults.standard.accessTokenDueDate = accessTokenDueDate
                let refreshTokenDueDate = Date().addingTimeInterval(1200 * 60)
                UserDefaults.standard.refreshTokenDueDate = refreshTokenDueDate
                fetchUserProfileTrigger.onNext(())
            } onError: { owner, error in
                print("로그인 오류 발생, \(error)")
            }
            .disposed(by: disposeBag)
            
        return Output(
            loginValidation: loginValid.asDriver(),
            loginSuccessTrigger: loginSuccessTrigger.asDriver(onErrorJustReturn: ()),
            moveToSignUpVC: input.goToSignUpButtonTapped.asDriver(), 
            loginFailTrigger: loginFailTrigger.asDriver(onErrorJustReturn: ""),
            showPasswordButtonTrigger: input.showPasswordButtonTapped.asDriver()
        )
    }
    
}
