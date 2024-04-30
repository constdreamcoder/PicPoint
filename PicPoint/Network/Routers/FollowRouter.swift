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
    case unfollow(params: UnFollowParams)
}

extension FollowRouter: TargetType {
    
    var baseURL: String {
        return APIKeys.baseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .follow:
            return .post
        case .unfollow:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .follow, .unfollow:
            return "/follow"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .follow, .unfollow:
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
        case .unfollow(let params):
            return "/\(params.userId)"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .follow, .unfollow:
            return nil
        }
    }
}


