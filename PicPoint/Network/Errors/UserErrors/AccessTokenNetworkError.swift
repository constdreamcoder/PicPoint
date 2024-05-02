//
//  AccessTokenNetworkError.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/2/24.
//

import Foundation

enum AccessTokenNetworkError: Int, LocalizedError {
    case unauthorizedAccessToken = 401
    case forbidden = 403
    case expiredFreshToken = 418
    
    var errorDescription: String? {
        switch self {
        case .unauthorizedAccessToken:
            return "\(self.rawValue)/인증할 수 없는 토근입니다."
        case .forbidden:
            return "\(self.rawValue)/Forbidden"
        case .expiredFreshToken:
            return "\(self.rawValue)/리프레시 토큰이 만료되었습니다. 다시 로그인 해주세요."
        }
    }
}
