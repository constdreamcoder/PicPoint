//
//  LikeManager.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/27/24.
//

import Foundation
import RxSwift
import Alamofire

struct LikeManager {
    static func fetchMyLikes() -> Single<[Post]> {
        return Single<[Post]>.create { singleObserver in
            do {
                let urlRequest = try LikeRouter.fetchMyLikes.asURLRequest()
                
                CustomSession.shared.session.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: FetchMyLikesModel.self) { response in
                        switch response.result {
                        case .success(let fetchMyLikesModel):
                            singleObserver(.success(fetchMyLikesModel.data))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode {
                                if let commonNetworkError = CommonNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(commonNetworkError))
                                } else if let fetchLikedPostsError = FetchLikedPostsNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(fetchLikedPostsError))
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
    
    static func like(params: LikeParams, body: LikeBody) -> Single<String> {
        return Single<String>.create { singleObserver in
            do {
                let urlRequest = try LikeRouter.like(params: params, body: body).asURLRequest()
                
                CustomSession.shared.session.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: LikeModel.self) { response in
                        switch response.result {
                        case .success(_):
                            singleObserver(.success(params.postId))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode {
                                if let commonNetworkError = CommonNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(commonNetworkError))
                                } else if let likeUnlikePostError = LikeUnlikePostNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(likeUnlikePostError))
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
    
    static func unlike(params: LikeParams, body: LikeBody) -> Single<String> {
        return Single<String>.create { singleObserver in
            do {
                let urlRequest = try LikeRouter.unlike(params: params, body: body).asURLRequest()
                
                CustomSession.shared.session.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: LikeModel.self) { response in
                        switch response.result {
                        case .success(_):
                            singleObserver(.success(params.postId))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode {
                                if let commonNetworkError = CommonNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(commonNetworkError))
                                } else if let likeUnlikePostError = LikeUnlikePostNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(likeUnlikePostError))
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


