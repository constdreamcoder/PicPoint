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
    case like(params: LikeParams, body: LikeBody)
    case unlike(params: LikeParams, body: LikeBody)
}

extension LikeRouter: TargetType {
    
    var baseURL: String {
        return APIKeys.baseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchMyLikes:
            return .get
        case .like, .unlike:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .fetchMyLikes:
            return "/posts/likes/me"
        case .like, .unlike:
            return "/posts"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .fetchMyLikes:
            return [
                HTTPHeader.sesacKey.rawValue: APIKeys.sesacKey,
            ]
        case .like, .unlike:
            return [
                HTTPHeader.sesacKey.rawValue: APIKeys.sesacKey,
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue
            ]
        }
    }
    
    var parameters: String? {
        switch self {
        case .fetchMyLikes:
            return nil
        case .like(let params, _):
            return "/\(params.postId)/like"
        case .unlike(let params, _):
            return "/\(params.postId)/like"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .fetchMyLikes:
            return nil
        case .like(_, let body):
            let encoder = JSONEncoder()
            return try? encoder.encode(body)
        case .unlike(_, let body):
            let encoder = JSONEncoder()
            return try? encoder.encode(body)
        }
    }
}

