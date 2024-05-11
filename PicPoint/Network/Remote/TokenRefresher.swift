//
//  TokenRefresher.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/4/24.
//

import Foundation
import Alamofire

final class TokenRefresher: RequestInterceptor {
        
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        let token = UserDefaults.standard.accessToken
        urlRequest.setValue(token, forHTTPHeaderField: HTTPHeader.authorization.rawValue)
        
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse,
              response.statusCode == 419
        else {
            completion(.doNotRetryWithError(error))
            return
        }
                
        let refreshToken = UserDefaults.standard.refreshToken
        if !refreshToken.isEmpty {
            UserManager.refreshToken { [weak self] response in
                guard let self else { return }
                switch response {
                case .success(let refreshedAccessToken):
                    UserDefaults.standard.accessToken = refreshedAccessToken
                    completion(.retry)
                case .failure(let error):
                    print("failure")
                    print(error.errorCode, error.errorDesc)
                    if error.errorCode == 418 || error.errorCode == 401 {
                        NotificationCenter.default.post(name: .refreshTokenExpired, object: nil, userInfo: ["showReloginAlert": true])
                    }
                    completion(.doNotRetryWithError(error))
                }
            }
        }
        
    }
}
