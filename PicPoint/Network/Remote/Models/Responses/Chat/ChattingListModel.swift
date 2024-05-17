//
//  ChattingListModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/16/24.
//

import Foundation

struct ChattingListModel: Decodable {
    let data: [Chat]
}

struct Chat: Decodable {
    let chatId: String
    let roomId: String
    let content: String?
    let createdAt: String
    let sender: Sender
    let files: [String]
    
    enum CodingKeys: String, CodingKey {
        case chatId = "chat_id"
        case roomId = "room_id"
        case content
        case createdAt
        case sender
        case files
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.chatId = try container.decode(String.self, forKey: .chatId)
        self.roomId = try container.decode(String.self, forKey: .roomId)
        self.content = try container.decodeIfPresent(String.self, forKey: .content) ?? ""
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.sender = try container.decode(Sender.self, forKey: .sender)
        self.files = try container.decode([String].self, forKey: .files)
    }
}

struct Sender: Decodable {
    let userId: String
    let nick: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.nick = try container.decode(String.self, forKey: .nick)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage) ?? ""
    }
}
