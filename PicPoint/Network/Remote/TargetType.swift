//
//  TargetType.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/13/24.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var method: HTTPMethod { get }
    var path: String { get }
    var header: [String: String] { get }
    var parameters: String? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
}

extension TargetType {
    func asURLRequest() throws -> URLRequest {
        
        var url = try baseURL.asURL().appendingPathComponent(path)
        
        if let params = parameters, !params.isEmpty {
            url = url.appending(path: params)
        }
        
        if let queryItems = queryItems, !queryItems.isEmpty {
            url = url.appending(queryItems: queryItems)
        }
        
        var urlRequest = try URLRequest(url: url, method: method)
        urlRequest.allHTTPHeaderFields = header
        urlRequest.httpBody = parameters?.data(using: .utf8)
        urlRequest.httpBody = body
        return urlRequest
    }
}
