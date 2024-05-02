//
//  DeleteCommentNetworkError.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/2/24.
//

import Foundation

enum DeleteCommentNetworkError: Int, LocalizedError {
    case unauthorizedAccessToken = 401
    case forbidden = 403
    case noCommentForDelete = 410
    case expiredAccessToken = 419
    case noRightToDeleteComment = 445
    
    var errorDescription: String? {
        switch self {
        case .unauthorizedAccessToken:
            return "\(self.rawValue)/인증할 수 없는 액세스 토큰입니다."
        case .forbidden:
            return "\(self.rawValue)/Forbidden"
        case .noCommentForDelete:
            return "\(self.rawValue)/삭제할 댓글을 찾을 수 없습니다."
        case .expiredAccessToken:
            return "\(self.rawValue)/액세스 토큰이 만료되었습니다."
        case .noRightToDeleteComment:
            return "\(self.rawValue)/댓글 삭제 권한이 없습니다."
        }
    }
}
