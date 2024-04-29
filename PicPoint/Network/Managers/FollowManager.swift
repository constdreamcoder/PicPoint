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
    static func follow(params: FollowParams) -> Single<FollowModel> {
        return Single<FollowModel>.create { singleObserver in
            do {
                let urlRequest = try FollowRouter.follow(params: params).asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: FollowModel.self) { response in
                        switch response.result {
                        case .success(let followModel):
                            singleObserver(.success(followModel))
                        case .failure(let AFError):
                            print(response.response?.statusCode)
                            print(AFError)
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

