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
                
                AF.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: FetchMyLikesModel.self) { response in
                        switch response.result {
                        case .success(let fetchMyLikesModel):
                            singleObserver(.success(fetchMyLikesModel.data))
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


