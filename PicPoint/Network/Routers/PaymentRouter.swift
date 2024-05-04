//
//  PaymentRouter.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/4/24.
//

import Foundation
import Alamofire

enum PaymentRouter {
    case validatePayment(body: ValidatePaymentBody)
}

extension PaymentRouter: TargetType {
    
    var baseURL: String {
        return APIKeys.paymentBaseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .validatePayment:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .validatePayment:
            return "/payments/validation"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .validatePayment:
            return [
                HTTPHeader.authorization.rawValue: UserDefaults.standard.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKeys.sesacKey
            ]
        }
    }
    
    var parameters: String? {
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
    
    var body: Data? {
        switch self {
        case .validatePayment(let body):
            let encoder = JSONEncoder()
            return try? encoder.encode(body)
        }
    }
}
