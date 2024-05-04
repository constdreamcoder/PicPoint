//
//  TokenRefresher.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/4/24.
//

import Foundation
import Alamofire

final class TokenRefresher: RequestInterceptor {
    
    private let retryLimit = 2
    
    deinit {
        print("deinit - TokenRefresher 해제")
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        if urlRequest.headers.dictionary[HTTPHeader.authorization.rawValue] == nil {
            let token = UserDefaults.standard.accessToken
            if !token.isEmpty {
                urlRequest.setValue(token, forHTTPHeaderField: HTTPHeader.authorization.rawValue)
            }
        }
        
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("1")
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 419
        else {
            print("2")
            completion(.doNotRetryWithError(error))
            return
        }
        
        print("response.statusCode", response.statusCode)
        completion(.doNotRetryWithError(error))

        print("3")
        guard request.retryCount < retryLimit
        else {
            print("4")
            return completion(.doNotRetryWithError(error))
        }
            
        print("5")
        let refreshToken = UserDefaults.standard.refreshToken
        if !refreshToken.isEmpty {
            print("6")
            UserManager.refreshToken { response in
                print("7")
                switch response {
                case .success(let refreshedAccessToken):
                    print("8")
                    UserDefaults.standard.accessToken = refreshedAccessToken
                    completion(.retry)
                case .failure(let error):
                    print("9")
                    print(error.errorCode, error.errorDesc)
                    if error.errorCode == 418 {
                        print("10")
                        NotificationCenter.default.post(name: .refreshTokenExpired, object: nil, userInfo: ["showReloginAlert": true])
                    }
                    print("11")
                    completion(.doNotRetryWithError(error))
                }
            }
        }
        
    }
}


