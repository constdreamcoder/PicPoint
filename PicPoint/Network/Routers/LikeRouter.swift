//
//  LikeRouter.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/27/24.
//

import Foundation
import Alamofire

enum LikeRouter {
    case fetchMyLikes
}

extension LikeRouter: TargetType {
    
    var baseURL: String {
        return APIKeys.baseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchMyLikes:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchMyLikes:
            return "/posts/likes/me"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .fetchMyLikes:
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
        case .fetchMyLikes:
            return nil
        }
    }
}

