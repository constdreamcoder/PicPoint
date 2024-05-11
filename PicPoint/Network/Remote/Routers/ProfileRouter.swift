//
//  ProfileRouter.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/26/24.
//

import Foundation
import Alamofire

enum ProfileRouter {
    case fetchMyProfile
    case editMyProfile(body: EditMyProfileBody)
    case fetchOtherProfile(params: FetchOtherProfileParams)
}

extension ProfileRouter: TargetType {
    
    var baseURL: String {
        return APIKeys.baseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchMyProfile, .fetchOtherProfile:
            return .get
        case .editMyProfile:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .fetchMyProfile, .editMyProfile:
            return "/users/me/profile"
        case .fetchOtherProfile:
            return "/users"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .fetchMyProfile, .fetchOtherProfile:
            return [
                HTTPHeader.sesacKey.rawValue: APIKeys.sesacKey
            ]
        case .editMyProfile:
            return [
                HTTPHeader.sesacKey.rawValue: APIKeys.sesacKey,
                HTTPHeader.contentType.rawValue: HTTPHeader.formData.rawValue
            ]
        }
    }
    
    var parameters: String? {
        switch self {
        case .fetchMyProfile, .editMyProfile:
            return nil
        case .fetchOtherProfile(let params):
            return "/\(params.userId)/profile"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .fetchMyProfile, .editMyProfile, .fetchOtherProfile:
            return nil
        }
    }
}
