//
//  FetchMyChatRoomListNetworkError.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/18/24.
//

import Foundation

enum FetchMyChatRoomListNetworkError: Int, LocalizedError {
    case unauthorizedAccessToken = 401
    case forbidden = 403
    case expiredAccessToken = 419
    
    var errorDescription: String? {
        switch self {
        case .unauthorizedAccessToken:
            return "\(self.rawValue)/인증할 수 없는 액세스 토큰입니다."
        case .forbidden:
            return "\(self.rawValue)/Forbidden"
        case .expiredAccessToken:
            return "\(self.rawValue)/액세스 토큰이 만료되었습니다."
        }
    }
}

