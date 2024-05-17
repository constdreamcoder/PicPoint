//
//  CreateRoomModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/17/24.
//

import Foundation

struct CreateRoomModel: Decodable {
    let roomId: String
    let createdAt: String
    let updatedAt: String
    let participants: [Sender]
    let lastChat: Chat?
    
    enum CodingKeys: String, CodingKey {
        case roomId = "room_id"
        case createdAt
        case updatedAt
        case participants
        case lastChat
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.roomId = try container.decode(String.self, forKey: .roomId)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        self.updatedAt = try container.decode(String.self, forKey: .updatedAt)
        self.participants = try container.decode([Sender].self, forKey: .participants)
        self.lastChat = try container.decodeIfPresent(Chat.self, forKey: .lastChat) ?? nil
    }
}
