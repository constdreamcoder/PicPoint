//
//  LoginManager.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/13/24.
//

import Foundation
import RxSwift
import Alamofire

struct LoginManager {
    static func login(query: LoginQuery) -> Single<LoginModel> {
        return Single<LoginModel>.create { single in
            do {
                let urlRequest = try Router.login(query: query).asURLRequest()
                print("url", urlRequest.url?.absoluteString)
                AF.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: LoginModel.self) { response in
                        switch response.result {
                        case .success(let loginModel):
                            single(.success(loginModel))
                        case .failure(let AFError):
                            print(response.response?.statusCode)
                            single(.failure(AFError))
                        }
                    }
            } catch {
                single(.failure(error))
            }
            return Disposables.create()
        }
    }
}
