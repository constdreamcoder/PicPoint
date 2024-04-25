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
    case writePost(body: WritePostBody)
    case deletePost(params: DeletePostParams)
    case fetchPostWithHashTag(query: FetchPostWithHashTagQuery)
}

extension PostRouter: TargetType {
    
    var baseURL: String {
        return APIKeys.baseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchPosts, .fetchPost, .fetchPostWithHashTag:
            return .get
        case .uploadImages, .writePost:
            return .post
        case .deletePost:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .fetchPosts, .fetchPost, .writePost, .deletePost:
            return "/posts"
        case .uploadImages:
            return "/posts/files"
        case .fetchPostWithHashTag:
            return "/posts/hashtags"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .fetchPosts, .fetchPost, .deletePost, .fetchPostWithHashTag:
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
        case .writePost:
            return [
                HTTPHeader.sesacKey.rawValue: APIKeys.sesacKey,
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.authorization.rawValue: UserDefaults.standard.accessToken,
            ]
        }
    }
    
    var parameters: String? {
        switch self {
        case .fetchPosts, .writePost, .fetchPostWithHashTag:
            return nil
        case .fetchPost(let params):
            return "/\(params.postId)"
        case .uploadImages:
            return nil
        case .deletePost(let params):
            return "/\(params.postId)"
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
        case .fetchPost, .uploadImages, .writePost, .deletePost:
            return nil
        case .fetchPostWithHashTag(let query):
            return [
                .init(name: "next", value: query.next),
                .init(name: "limit", value: query.limit),
                .init(name: "product_id", value: query.product_id),
                .init(name: "hashTag", value: query.hashTag)
                
            ]
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchPosts, .fetchPost, .uploadImages, .deletePost, .fetchPostWithHashTag:
            return nil
        case .writePost(let body):
            let encoder = JSONEncoder()
            return try? encoder.encode(body)
        }
    }
}
