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
}

extension ProfileRouter: TargetType {
    
    var baseURL: String {
        return APIKeys.baseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchMyProfile:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchMyProfile:
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
        case .fetchMyProfile:
            return nil
        }
    }
}
