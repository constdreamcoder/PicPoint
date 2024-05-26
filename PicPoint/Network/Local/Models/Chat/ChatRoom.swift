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
    @Persisted var lastChat: LastChatMessage?
    
    convenience init(
        roomId: String,
        createdAt: String,
        updatedAt: String,
        participants: [User],
        lastChat: LastChatMessage?
    ) {
        self.init()
        
        self.roomId = roomId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        participants.forEach { [weak self] participant in
            guard let self else { return }
            self.participants.append(participant)
        }
        
        ChatRoomMessageRepository.shared.read().forEach { [weak self] message in
            guard let self else { return }
            if message.roomId == roomId {
                messages.append(message)
            }
        }
        
        self.lastChat = lastChat
    }
}

final class LastChatMessage: EmbeddedObject {
    @Persisted var chatId: String
    @Persisted var roomId: String
    @Persisted var content: String?
    @Persisted var createdAt: String
    @Persisted var sender: User?
    @Persisted var files: List<String>
    
    convenience init(
        chatId: String,
        roomId: String,
        content: String? = nil,
        createdAt: String,
        sender: User? = nil,
        files: [String]
    ) {
        self.init()
        
        self.chatId = chatId
        self.roomId = roomId
        self.content = content
        self.createdAt = createdAt
        self.sender = sender
        files.forEach { [weak self] file in
            guard let self else { return }
            self.files.append(file)
        }
    }
}
