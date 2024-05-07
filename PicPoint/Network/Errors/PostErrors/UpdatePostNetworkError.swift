//
//  UpdatePostNetworkError.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/8/24.
//

import Foundation

enum UpdatePostNetworkError: Int, LocalizedError {
    case unauthorizedAccessToken = 401
    case forbidden = 403
    case cannotFindPostForUpdate = 410
    case expiredAccessToken = 419
    case noRightToUpdate = 445
    
    var errorDescription: String? {
        switch self {
        case .unauthorizedAccessToken:
            return "\(self.rawValue)/인증할 수 없는 액세스 토큰입니다."
        case .forbidden:
            return "\(self.rawValue)/Forbidden"
        case .cannotFindPostForUpdate:
            return "\(self.rawValue)/수정할 게시글을 찾을 수 없습니다."
        case .expiredAccessToken:
            return "\(self.rawValue)/액세스 토큰이 만료되었습니다."
        case .noRightToUpdate:
            return "\(self.rawValue)/게시글 수정 권한이 없습니다."
        }
    }
}
