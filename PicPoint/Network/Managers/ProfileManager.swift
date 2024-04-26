//
//  ProfileManager.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/26/24.
//

import Foundation
import RxSwift
import Alamofire

struct ProfileManager {
    static func fetchMyProfile() -> Single<FetchMyProfileModel> {
        return Single<FetchMyProfileModel>.create { singleObserver in
            do {
                let urlRequest = try ProfileRouter.fetchMyProfile.asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: FetchMyProfileModel.self) { response in
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
}

