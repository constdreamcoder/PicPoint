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
                        case .success(let fetchMyProfileModel):
                            singleObserver(.success(fetchMyProfileModel))
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
    
    static func editMyProfile(body: EditMyProfileBody) -> Single<FetchMyProfileModel> {
        return Single<FetchMyProfileModel>.create { singleObserver in
            do {
                let urlRequest = try ProfileRouter.editMyProfile(body: body).asURLRequest()
                
                guard let url = urlRequest.url else { return Disposables.create() }
                print("url", url)
                guard let method = urlRequest.method else { return Disposables.create() }
                
                let headers = urlRequest.headers
                
                AF.upload(multipartFormData: { multipartFormData in
                    multipartFormData.append(body.nick.data(using: .utf8)!, withName: EditMyProfileBody.Key.nick)
                    multipartFormData.append(body.phoneNum.data(using: .utf8)!, withName: EditMyProfileBody.Key.phoneNum)
                    multipartFormData.append(body.birthDay.data(using: .utf8)!, withName: EditMyProfileBody.Key.birthDay)
                    multipartFormData.append(
                        body.profileImage.imageData,
                        withName: EditMyProfileBody.Key.profileImage,
                        fileName: body.profileImage.name,
                        mimeType: body.profileImage.mimeType.rawValue
                    )
                }, to: url, method: method, headers: headers)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: FetchMyProfileModel.self) { response in
                        switch response.result {
                        case .success(let postListModel):
                            singleObserver(.success(postListModel))
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
