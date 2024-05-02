//
//  FollowNetworkError.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/2/24.
//

import Foundation

enum FollowNetworkError: Int, LocalizedError {
    case badRequest = 400
    case unauthorizedAccessToken = 401
    case forbidden = 403
    case alreadyFollowed = 409
    case unknownedAccount = 410
    case expiredAccessToken = 419
    
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "\(self.rawValue)/잘못된 요청입니다."
        case .unauthorizedAccessToken:
            return "\(self.rawValue)/인증할 수 없는 액세스 토큰입니다."
        case .forbidden:
            return "\(self.rawValue)/Forbidden"
        case .alreadyFollowed:
            return "\(self.rawValue)/이미 팔로윙 된 계정입니다."
        case .unknownedAccount:
            return "\(self.rawValue)/알 수 없는 계정입니다."
        case .expiredAccessToken:
            return "\(self.rawValue)/액세스 토큰이 만료되었습니다."
        }
    }
}
