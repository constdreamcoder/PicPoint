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
    case fetchPaymentList
}

extension PaymentRouter: TargetType {
    
    var baseURL: String {
        return APIKeys.baseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .validatePayment:
            return .post
        case .fetchPaymentList:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .validatePayment:
            return "/payments/validation"
        case .fetchPaymentList:
            return "/payments/me"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .validatePayment, .fetchPaymentList:
            return [
                HTTPHeader.authorization.rawValue: UserDefaults.standard.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKeys.sesacKey,
                HTTPHeader.contentType.rawValue:  HTTPHeader.json.rawValue
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
        case .fetchPaymentList:
            return nil
        }
    }
}
