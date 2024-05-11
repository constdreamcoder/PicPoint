//
//  ValidatePaymentNetworkError.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/4/24.
//

import Foundation

enum ValidatePaymentNetworkError: Int, LocalizedError {
    case badPayment = 400
    case unauthorizedAccessToken = 401
    case forbidden = 403
    case completedValidation = 409
    case cannotFindPost = 410
    case expiredAccessToken = 419
    
    var errorDescription: String? {
        switch self {
        case .badPayment:
            return "\(self.rawValue)/유효하지 않은 결제건이거나 필수값을 채워주세요."
        case .unauthorizedAccessToken:
            return "\(self.rawValue)/인증할 수 없는 액세스 토큰입니다."
        case .forbidden:
            return "\(self.rawValue)/Forbidden"
        case .completedValidation:
            return "\(self.rawValue)/검증처리가 완료된 결제건입니다."
        case .cannotFindPost:
            return "\(self.rawValue)/게시글을 찾을 수 없습니다."
        case .expiredAccessToken:
            return "\(self.rawValue)/액세스 토큰이 만료되었습니다."
        }
    }
}
