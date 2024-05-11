//
//  SignUpNetworkError.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/2/24.
//

import Foundation

enum SignUpNetworkError: Int, LocalizedError {
    case missingEssentials = 400
    case alreadyJoined = 409
    
    var errorDescription: String? {
        switch self {
        case .missingEssentials:
            return "\(self.rawValue)/필수값을 채워주세요."
        case .alreadyJoined:
            return "\(self.rawValue)/이미 가입된 계정입니다."
        }
    }
}
