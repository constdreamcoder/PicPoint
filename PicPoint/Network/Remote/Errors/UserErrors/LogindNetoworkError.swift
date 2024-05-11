//
//  LogindNetoworkError.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/2/24.
//

import Foundation

enum LoginNetworkError: Int, LocalizedError {
    case missingEssentials = 400
    case invalidAccount = 401
    
    var errorDescription: String? {
        switch self {
        case .missingEssentials:
            return "\(self.rawValue)/필수값을 채워주세요"
        case .invalidAccount:
            return "\(self.rawValue)/계정을 확인해주세요."
        }
    }
}
