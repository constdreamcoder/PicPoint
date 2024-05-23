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
    case fetchMyChatRoomList
    case uploadImages(params: UploadImagesParams, body: UploadImagesBody)
}

extension ChatRouter: TargetType {
    
    var baseURL: String {
        return APIKeys.baseURL
    }
    
    var method: HTTPMethod {
        switch self {
        case .createRoom, .sendChat, .uploadImages:
            return .post
        case .fetchChattingHistory, .fetchMyChatRoomList:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .createRoom, .fetchChattingHistory, .sendChat, .fetchMyChatRoomList, .uploadImages:
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
        case .fetchChattingHistory, .fetchMyChatRoomList:
            return [
                HTTPHeader.sesacKey.rawValue: APIKeys.sesacKey,
            ]
        case .uploadImages:
            return [
                HTTPHeader.sesacKey.rawValue: APIKeys.sesacKey,
                HTTPHeader.contentType.rawValue: HTTPHeader.formData.rawValue
            ]
        }
    }
    
    var parameters: String? {
        switch self {
        case .createRoom, .fetchMyChatRoomList:
            return nil
        case .fetchChattingHistory(let params, _):
            return "/\(params.roomId)"
        case .sendChat(let params, _):
            return "/\(params.roomId)"
        case .uploadImages(let params, _):
            return "/\(params.roomId)/files"
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .createRoom, .sendChat, .fetchMyChatRoomList, .uploadImages:
            return nil
        case .fetchChattingHistory(_, let query):
            return [
                .init(name: "cursor_date", value: query.cursor_date)
            ]
        }
    }
    
    var body: Data? {
        switch self {
        case .fetchChattingHistory, .fetchMyChatRoomList, .uploadImages:
            return nil
        case .createRoom(let body):
            let encoder = JSONEncoder()
            return try? encoder.encode(body)
        case .sendChat(_, let body):
            let encoder = JSONEncoder()
            return try? encoder.encode(body)
        }
    }
}
