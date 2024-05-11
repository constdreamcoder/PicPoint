//
//  DeletePostNetworkError.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/2/24.
//

import Foundation

enum DeletePostNetworkError: Int, LocalizedError {
    case unauthorizedAccessToken = 401
    case forbidden = 403
    case cannotFindPostForDelete = 410
    case expiredAccessToken = 419
    case noRightToDeletePost = 445
    
    var errorDescription: String? {
        switch self {
        case .unauthorizedAccessToken:
            return "\(self.rawValue)/인증할 수 없는 액세스 토큰입니다."
        case .forbidden:
            return "\(self.rawValue)/Forbidden"
        case .cannotFindPostForDelete:
            return "\(self.rawValue)/삭제할 게시글을 찾을 수 없습니다."
        case .expiredAccessToken:
            return "\(self.rawValue)/액세스 토큰이 만료되었습니다."
        case .noRightToDeletePost:
            return "게시글 삭제 권한이 없습니다."
        }
    }
}
