//
//  LoginManager.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/13/24.
//

import Foundation
import RxSwift
import Alamofire

struct UserManager {
    static func login(body: LoginBody) -> Single<LoginModel> {
        return Single<LoginModel>.create { singleObserver in
            do {
                let urlRequest = try UserRouter.login(body: body).asURLRequest()
                
                CustomSession.shared.session.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: LoginModel.self) { response in
                        switch response.result {
                        case .success(let loginModel):
                            singleObserver(.success(loginModel))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode {
                                if let commentNetworkError = CommonNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(commentNetworkError))
                                } else if let loginError = LoginNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(loginError))
                                } else {
                                    singleObserver(.failure(CommonNetworkError.unknownError))
                                }
                            }
                        }
                    }
            } catch {
                singleObserver(.failure(CommonNetworkError.unknownError))
            }
            return Disposables.create()
        }
    }
    
    static func signUp(body: SignUpBody) -> Single<SignUpModel> {
        return Single<SignUpModel>.create { singleObserver in
            do {
                let urlRequest = try UserRouter.signUp(body: body).asURLRequest()
                
                CustomSession.shared.session.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: SignUpModel.self) { response in
                        switch response.result {
                        case .success(let signUpModel):
                            singleObserver(.success(signUpModel))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode {
                                if let commonNetworkError = CommonNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(commonNetworkError))
                                } else if let signUpError = SignUpNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(signUpError))
                                } else {
                                    singleObserver(.failure(CommonNetworkError.unknownError))
                                }
                            }
                        }
                    }
            } catch {
                singleObserver(.failure(CommonNetworkError.unknownError))
            }
            return Disposables.create()
        }
    }
    
    static func withdraw() -> Single<WithdrawalModel> {
        return Single<WithdrawalModel>.create { singleObserver in
            do {
                let urlRequest = try UserRouter.withdrawal.asURLRequest()
                
                CustomSession.shared.session.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: WithdrawalModel.self) { response in
                        switch response.result {
                        case .success(let withdrawalModel):
                            singleObserver(.success(withdrawalModel))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode {
                                if let commonNetworkError = CommonNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(commonNetworkError))
                                } else if let withdralError = WithdralNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(withdralError))
                                } else {
                                    singleObserver(.failure(CommonNetworkError.unknownError))
                                }
                            }
                        }
                    }
            } catch {
                singleObserver(.failure(CommonNetworkError.unknownError))
            }
            return Disposables.create()
        }
    }
    
    static func validateEmail(body: ValidateEmailBody) -> Single<ValidateEmailModel> {
        return Single<ValidateEmailModel>.create { singleObserver in
            do {
                let urlRequest = try UserRouter.validateEmail(body: body).asURLRequest()
                
                CustomSession.shared.session.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: ValidateEmailModel.self) { response in
                        switch response.result {
                        case .success(let withdrawalModel):
                            if response.response?.statusCode == 200 {
                                singleObserver(.success(ValidateEmailModel(message: "200")))
                            } else {
                                singleObserver(.success(withdrawalModel))
                            }
                        case .failure(_):
                            if let statusCode = response.response?.statusCode {
                                if let commonNetworkError = CommonNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(commonNetworkError))
                                } else if let validateEmailError = ValidateEmailNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(validateEmailError))
                                } else {
                                    singleObserver(.failure(CommonNetworkError.unknownError))
                                }
                            }
                        }
                    }
            } catch {
                singleObserver(.failure(CommonNetworkError.unknownError))
            }
            return Disposables.create()
        }
    }
    
    static func refreshToken(completionHandler: @escaping (Result<String, Error>) -> Void) {
        do {
            let urlRequest = try UserRouter.refreshToken.asURLRequest()
            
            AF.request(urlRequest)
                .validate(statusCode: 200...500)
                .responseDecodable(of: RefreshTokenModel.self) { response in
                    
                    switch response.result {
                    case .success(let refreshedToken):
                        completionHandler(.success(refreshedToken.accessToken))
                    case .failure(_):
                        if let statusCode = response.response?.statusCode {
                            if let commonNetworkError = CommonNetworkError(rawValue: statusCode) {
                                completionHandler(.failure(commonNetworkError))
                            } else if let accessTokeError = AccessTokenNetworkError(rawValue: statusCode) {
                                completionHandler(.failure(accessTokeError))
                            } else {
                                completionHandler(.failure(CommonNetworkError.unknownError))
                            }
                        }
                    }
                }
        } catch {
            completionHandler(.failure(CommonNetworkError.unknownError))
        }
    }
}
