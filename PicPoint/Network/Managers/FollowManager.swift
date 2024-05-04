//
//  FollowManager.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/29/24.
//

import Foundation
import RxSwift
import Alamofire

struct FollowManager {
    static func follow(params: FollowParams) -> Single<String> {
        return Single<String>.create { singleObserver in
            do {
                let urlRequest = try FollowRouter.follow(params: params).asURLRequest()
                
                AF.request(urlRequest, interceptor: TokenRefresher())
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: FollowModel.self) { response in
                        switch response.result {
                        case .success(_):
                            singleObserver(.success(params.userId))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode {
                                if let commonNetworkError = CommonNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(commonNetworkError))
                                } else if let followError = FollowNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(followError))
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
    
    static func unfollow(params: UnFollowParams) -> Single<String> {
        return Single<String>.create { singleObserver in
            do {
                let urlRequest = try FollowRouter.unfollow(params: params).asURLRequest()
                
                AF.request(urlRequest, interceptor: TokenRefresher())
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: FollowModel.self) { response in
                        switch response.result {
                        case .success(_):
                            singleObserver(.success(params.userId))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode {
                                if let commonNetworkError = CommonNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(commonNetworkError))
                                } else if let UnfollowError = UnfollowNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(UnfollowError))
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

}

