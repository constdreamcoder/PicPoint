//
//  ChatRouter.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/17/24.
//

import Foundation
import Alamofire

enum ChatRouter {
    case createRoom(body: CreateRoomBody)
    case fetchChattingHistory(params: FetchChattingHistoryParams, query: FetchChattingHistoryQuery)
    case sendChat(params: SendChatParams, body: SendChatBody)
}

extension ChatRouter: TargetType {
    
    var baseURL: String {
        return APIKeys.baseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .createRoom, .sendChat:
            return .post
        case .fetchChattingHistory:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .createRoom, .fetchChattingHistory, .sendChat:
            return "/chats"
        }
    }
    
    var header: [String : String] {
        switch self {
        case .createRoom, .sendChat:
            return [
                HTTPHeader.sesacKey.rawValue: APIKeys.sesacKey,
                HTTPHeader.contentType.rawValue: HTTPHeader.json.rawValue
            ]
        case .fetchChattingHistory:
            return [
                HTTPHeader.sesacKey.rawValue: APIKeys.sesacKey,
            ]
        }
    }
    
    var parameters: String? {
        switch self {
        case .createRoom:
            return nil
        case .fetchChattingHistory(let params, _):
            return "/\(params.roomId)"
        case .sendChat(let params, _):
            return "/\(params.roomId)"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .createRoom, .sendChat:
            return nil
        case .fetchChattingHistory(_, let query):
            return [
                .init(name: "cursor_date", value: query.cursor_date)
            ]
        }
    }
    
    var body: Data? {
        switch self {
        case .createRoom(let body):
            let encoder = JSONEncoder()
            return try? encoder.encode(body)
        case .fetchChattingHistory:
            return nil
        case .sendChat(_, let body):
            let encoder = JSONEncoder()
            return try? encoder.encode(body)
        }
    }
}
