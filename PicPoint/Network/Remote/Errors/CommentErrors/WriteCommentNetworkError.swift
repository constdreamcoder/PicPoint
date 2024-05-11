//
//  WriteCommentNetworkError.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/2/24.
//

import Foundation

enum WriteCommentNetworkError: Int, LocalizedError {
    case missingEsentials = 400
    case unauthorizedAccessToken = 401
    case forbidden = 403
    case noCommentForCreate = 410
    case expiredAccessToken = 419
    
    var errorDescription: String? {
        switch self {
        case .missingEsentials:
            return "\(self.rawValue)/필수값이 누락되었습니다."
        case .unauthorizedAccessToken:
            return "\(self.rawValue)/인증할 수 없는 액세스 토큰입니다."
        case .forbidden:
            return "\(self.rawValue)/Forbidden"
        case .noCommentForCreate:
            return "\(self.rawValue)/생성된 댓글 혹은 댓글을 추가할 게시글을 찾을 수 없습니다."
        case .expiredAccessToken:
            return "\(self.rawValue)/액세스 토큰이 만료되었습니다."
        }
    }
}
