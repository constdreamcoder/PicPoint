//
//  CommonNetworkError.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/2/24.
//

import Foundation

enum CommonNetworkError: Int, LocalizedError {
    case invalidSesacKey = 420
    case excessiveCalls = 429
    case invalidURL = 444
    case serveError = 500
    case unknownError = 999
    
    var errorDescription: String? {
        switch self {
        case .invalidSesacKey:
            return "\(self.rawValue)/유효한 새싹키가 아닙니다."
        case .excessiveCalls:
            return "\(self.rawValue)/과도하게 호출되었습니다."
        case .invalidURL:
            return "\(self.rawValue)/유효하지 않은 URL로 요청하셨습니다."
        case .serveError:
            return "\(self.rawValue)/서버 오류"
        case .unknownError:
            return "\(self.rawValue)/알 수 없는 오류가 발생하였습니다."
        }
    }
}
