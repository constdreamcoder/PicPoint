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
    static func login(query: LoginQuery) -> Single<LoginModel> {
        return Single<LoginModel>.create { singleObserver in
            do {
                let urlRequest = try Router.login(query: query).asURLRequest()
                
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
    
    static func signUp(query: SignUpQuery) -> Single<SignUpModel> {
        return Single<SignUpModel>.create { singleObserver in
            do {
                let urlRequest = try Router.signUp(query: query).asURLRequest()
                
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
                let urlRequest = try Router.withdrawal.asURLRequest()
                
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
}
