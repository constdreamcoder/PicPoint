//
//  Router.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/13/24.
//

import Foundation
import Alamofire

enum UserRouter {
    case login(body: LoginBody)
    case signUp(body: SignUpBody)
    case withdrawal
    case validateEmail(body: ValidateEmailBody)
    case refreshToken
}

extension UserRouter: TargetType {
    
    var baseURL: String {
        return APIKeys.baseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .signUp, .validateEmail:
            return .post
        case .withdrawal, .refreshToken:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .login:
            return "/users/login"
        case .signUp:
            return "/users/join"
        case .withdrawal:
            return "/users/withdraw"
        case .validateEmail:
            return "/validation/email"
        case .refreshToken:
            return "/auth/refresh"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .login, .signUp, .validateEmail:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKeys.sesacKey
            ]
        case .withdrawal:
            return [
                HTTPHeader.sesacKey.rawValue: APIKeys.sesacKey
            ]
        case .refreshToken:
            return [
                HTTPHeader.authorization.rawValue: UserDefaultsManager.accessToken,
                HTTPHeader.sesacKey.rawValue: APIKeys.sesacKey,
                HTTPHeader.refresh.rawValue: UserDefaultsManager.refreshToken
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
        case .login(let body):
            let encoder = JSONEncoder()
            return try? encoder.encode(body)
        case .signUp(let body):
            let encoder = JSONEncoder()
            return try? encoder.encode(body)
        case .withdrawal, .refreshToken:
            return nil
        case .validateEmail(let body):
            let encoder = JSONEncoder()
            return try? encoder.encode(body)
        }
    }
}
