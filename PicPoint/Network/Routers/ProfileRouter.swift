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
}

extension ProfileRouter: TargetType {
    
    var baseURL: String {
        return APIKeys.baseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchMyProfile:
            return .get
        case .editMyProfile:
            return .put
        }
    }
    
    var path: String {
        switch self {
        case .fetchMyProfile, .editMyProfile:
            return "/users/me/profile"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .fetchMyProfile:
            return [
                HTTPHeader.authorization.rawValue: UserDefaults.standard.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKeys.sesacKey
            ]
        case .editMyProfile:
            return [
                HTTPHeader.authorization.rawValue: UserDefaults.standard.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKeys.sesacKey,
                HTTPHeader.contentType.rawValue: HTTPHeader.formData.rawValue
            ]
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .fetchMyProfile, .editMyProfile:
            return nil
        }
    }
}
