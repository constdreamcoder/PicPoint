//
//  ChatRoom.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/23/24.
//

import Foundation
import RealmSwift

final class ChatRoom: Object {
    @Persisted(primaryKey: true) var roomId: String
    @Persisted var createdAt: String
    @Persisted var updatedAt: String
    @Persisted var participants: List<User>
    @Persisted var messages: List<ChatRoomMessage>
    
    convenience init(
        roomId: String,
        createdAt: String,
        updatedAt: String,
        participants: [User]
    ) {
        self.init()
        
        self.roomId = roomId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        participants.forEach { participant in
            self.participants.append(participant)
        }
    }
}
