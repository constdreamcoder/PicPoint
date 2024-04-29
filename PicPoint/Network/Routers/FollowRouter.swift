//
//  FollowRouter.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/29/24.
//

import Foundation
import Alamofire

enum FollowRouter {
    case follow(params: FollowParams)
}

extension FollowRouter: TargetType {
    
    var baseURL: String {
        return APIKeys.baseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .follow:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .follow:
            return "/follow"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .follow:
            return [
                HTTPHeader.authorization.rawValue: UserDefaults.standard.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKeys.sesacKey
            ]
        }
    }
    
    var parameters: String? {
        switch self {
        case .follow(let params):
            return "/\(params.userId)"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .follow:
            return nil
        }
    }
}


