//
//  FetchChattingHistoryNetworkError.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/17/24.
//

import Foundation

enum FetchChattingHistoryNetworkError: Int, LocalizedError {
    case unauthorizedAccessToken = 401
    case forbidden = 403
    case unknownRoom = 410
    case expiredAccessToken = 419
    case notParticipant = 445
    
    var errorDescription: String? {
        switch self {
        case .unauthorizedAccessToken:
            return "\(self.rawValue)/인증할 수 없는 액세스 토큰입니다."
        case .forbidden:
            return "\(self.rawValue)/Forbidden"
        case .unknownRoom:
            return "\(self.rawValue)/존재하지 않는 채팅방입니다."
        case .expiredAccessToken:
            return "\(self.rawValue)/액세스 토큰이 만료되었습니다."
        case .notParticipant:
            return "\(self.rawValue)/채팅방 참여자가 아닙니다."
        }
    }
}
