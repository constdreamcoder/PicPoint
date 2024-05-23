//
//  UploadChatImagesNetworkError.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/21/24.
//

import Foundation

enum UploadChatImagesNetworkError: Int, LocalizedError {
    case badRequest = 400
    case unauthorizedAccessToken = 401
    case forbidden = 403
    case invalidChatRoomOrWithdrawnUser = 410
    case expiredAccessToken = 419
    case notParticipant = 445
    
    var errorDescription: String? {
        switch self {
        case .badRequest:
            return "\(self.rawValue)/잘못된 요청입니다."
        case .unauthorizedAccessToken:
            return "\(self.rawValue)/인증할 수 없는 액세스 토큰입니다."
        case .forbidden:
            return "\(self.rawValue)/Forbidden"
        case .invalidChatRoomOrWithdrawnUser:
            return "\(self.rawValue)/채팅방을 찾을 수 없거나 알 수 없는 계정입니다."
        case .expiredAccessToken:
            return "\(self.rawValue)/액세스 토큰이 만료되었습니다."
        case .notParticipant:
            return "\(self.rawValue)/채팅방 참여자가 아닙니다."
        }
    }
}
import Foundation
