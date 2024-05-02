//
//  WritePostNetworkError.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/2/24.
//

import Foundation

enum WritePostNetworkError: Int, LocalizedError {
    case unauthorizedAccessToken = 401
    case forbidden = 403
    case noCreatedPost = 410
    case expiredAccessToken = 419
    
    var errorDescription: String? {
        switch self {
        case .unauthorizedAccessToken:
            return "\(self.rawValue)/인증할 수 없는 액세스 토큰입니다."
        case .forbidden:
            return "\(self.rawValue)/Forbidden"
        case .noCreatedPost:
            return "\(self.rawValue)/생성된 게시글이 없습니다."
        case .expiredAccessToken:
            return "\(self.rawValue)/액세스 토큰이 만료되었습니다."
        }
    }
}
