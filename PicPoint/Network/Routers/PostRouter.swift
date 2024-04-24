//
//  PostRouter.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/16/24.
//

import Foundation
import Alamofire

enum PostRouter {
    case fetchPosts(query: FetchPostsQuery)
    case fetchPost(params: FetchPostParams)
    case uploadImages(body: UploadImagesBody)
}

extension PostRouter: TargetType {
    
    var baseURL: String {
        return APIKeys.baseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchPosts, .fetchPost:
            return .get
        case .uploadImages:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .fetchPosts, .fetchPost:
            return "/posts"
        case .uploadImages:
            return "/posts/files"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .fetchPosts, .fetchPost:
            return [
                HTTPHeader.authorization.rawValue: UserDefaults.standard.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKeys.sesacKey
            ]
        case .uploadImages:
            return [
                HTTPHeader.sesacKey.rawValue: APIKeys.sesacKey,
                HTTPHeader.contentType.rawValue: HTTPHeader.formData.rawValue,
                HTTPHeader.authorization.rawValue: UserDefaults.standard.accessToken,
            ]
        }
    }
    
    var parameters: String? {
        switch self {
        case .fetchPosts:
            return nil
        case .fetchPost(let params):
            return "/\(params.postId)"
        case .uploadImages:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchPosts(let query):
            return [
                .init(name: "next", value: query.next),
                .init(name: "limit", value: query.limit),
                .init(name: "product_id", value: query.product_id)
            ]
        case .fetchPost, .uploadImages:
            return nil
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchPosts, .fetchPost, .uploadImages:
            return nil
        }
    }
}
