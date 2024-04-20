//
//  CommentRouter.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/21/24.
//

import Foundation
import Alamofire

enum CommentRouter {
    case writeComment(params: WriteCommentParams, body: WriteCommentBody)
    case deleteComment(params: DeleteCommentParams)
}

extension CommentRouter: TargetType {
    
    var baseURL: String {
        return APIKeys.baseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .writeComment:
            return .post
        case .deleteComment:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .writeComment, .deleteComment:
            return "/posts"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .writeComment:
            return [
                HTTPHeader.authorization.rawValue: UserDefaults.standard.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKeys.sesacKey,
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue
            ]
        case .deleteComment:
            return [
                HTTPHeader.authorization.rawValue: UserDefaults.standard.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKeys.sesacKey
            ]
        }
    }
    
    var parameters: String? {
        switch self {
        case .writeComment(let params, _):
            return "/\(params.postId)/comments"
        case .deleteComment(let params):
            return "/\(params.postId)/comments/\(params.commentId)"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .writeComment( _, let body):
            let encoder = JSONEncoder()
            return try? encoder.encode(body)
        case .deleteComment:
            return nil
        }
    }
}
