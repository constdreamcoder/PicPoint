//
//  ValidateEmailNetworkError.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/2/24.
//

import Foundation

enum ValidateEmailNetworkError: Int, LocalizedError {
    case missingEssentials = 400
    case validatedEmail = 409
    
    var errorDescription: String? {
        switch self {
        case .missingEssentials:
            return "\(self.rawValue)/필수값을 채워주세요."
        case .validatedEmail:
            return "\(self.rawValue)/사용이 불가한 이메일입니다."
        }
    }
}
