//
//  CustomSession.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/9/24.
//

import Foundation
import Alamofire

final class CustomSession {
    static let shared = CustomSession()
    
    private init() {}
    
    let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 30
        let apiLogger = EventLogger()
        let interceptor = TokenRefresher()
        
        return Session(
            configuration: configuration,
            interceptor: interceptor,
            eventMonitors: [apiLogger])
    }()
}
