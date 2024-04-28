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
                
                AF.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: LoginModel.self) { response in
                        switch response.result {
                        case .success(let loginModel):
                            singleObserver(.success(loginModel))
                        case .failure(let AFError):
                            print(response.response?.statusCode)
                            singleObserver(.failure(AFError))
                        }
                    }
            } catch {
                singleObserver(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    static func signUp(body: SignUpBody) -> Single<SignUpModel> {
        return Single<SignUpModel>.create { singleObserver in
            do {
                let urlRequest = try UserRouter.signUp(body: body).asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: SignUpModel.self) { response in
                        switch response.result {
                        case .success(let signUpModel):
                            singleObserver(.success(signUpModel))
                        case .failure(let AFError):
                            print(response.response?.statusCode)
                            singleObserver(.failure(AFError))
                        }
                    }
            } catch {
                singleObserver(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    static func withdraw() -> Single<WithdrawalModel> {
        return Single<WithdrawalModel>.create { singleObserver in
            do {
                let urlRequest = try UserRouter.withdrawal.asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: WithdrawalModel.self) { response in
                        switch response.result {
                        case .success(let withdrawalModel):
                            singleObserver(.success(withdrawalModel))
                        case .failure(let AFError):
                            print(response.response?.statusCode)
                            singleObserver(.failure(AFError))
                        }
                    }
            } catch {
                singleObserver(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    static func validateEmail(body: ValidateEmailBody) -> Single<ValidateEmailModel> {
        return Single<ValidateEmailModel>.create { singleObserver in
            do {
                let urlRequest = try UserRouter.validateEmail(body: body).asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: ValidateEmailModel.self) { response in
                        switch response.result {
                        case .success(let withdrawalModel):
                            print(response.response?.statusCode)
                            if response.response?.statusCode == 200 {
                                singleObserver(.success(ValidateEmailModel(message: "200")))
                            } else {
                                singleObserver(.success(withdrawalModel))
                            }
                        case .failure(let AFError):
                            print(response.response?.statusCode)
                            singleObserver(.failure(AFError))
                        }
                    }
            } catch {
                singleObserver(.failure(error))
            }
            return Disposables.create()
        }
        
    }
}
