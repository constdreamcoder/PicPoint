//
//  EditCommentNetworkError.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/2/24.
//

import Foundation

enum EditCommentNetworkError: Int, LocalizedError {
    case missingEsentials = 400
    case unauthorizedAccessToken = 401
    case forbidden = 403
    case noCommentForEdit = 410
    case expiredAccessToken = 419
    case noRightToEditComment = 445
    
    var errorDescription: String? {
        switch self {
        case .missingEsentials:
            return "\(self.rawValue)/필수값이 누락되었습니다."
        case .unauthorizedAccessToken:
            return "\(self.rawValue)/인증할 수 없는 액세스 토큰입니다."
        case .forbidden:
            return "\(self.rawValue)/Forbidden"
        case .noCommentForEdit:
            return "\(self.rawValue)/수정할 댓글을 찾을 수 없습니다."
        case .expiredAccessToken:
            return "\(self.rawValue)/액세스 토큰이 만료되었습니다."
        case .noRightToEditComment:
            return "\(self.rawValue)/댓글 수정 권한이 없습니다."
        }
    }
}
