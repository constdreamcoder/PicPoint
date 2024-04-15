//
//  Router.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/13/24.
//

import Foundation
import Alamofire

enum Router {
    case login(query: LoginQuery)
    case signUp(query: SignUpQuery)
    case withdrawal
}

extension Router: TargetType {
    
    var baseURL: String {
        return APIKeys.baseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .login, .signUp:
            return .post
        case .withdrawal:
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
        }
    }
    
    var header: [String : String] {
        switch self {
        case .login, .signUp:
            return [
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue,
                HTTPHeader.sesacKey.rawValue: APIKeys.sesacKey
            ]
        case .withdrawal:
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
        case .login(let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        case .signUp(query: let query):
            let encoder = JSONEncoder()
            return try? encoder.encode(query)
        case .withdrawal:
            return nil
        }
    }
}
