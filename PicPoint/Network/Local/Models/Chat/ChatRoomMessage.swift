//
//  ChatRoomMessage.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/23/24.
//

import Foundation
import RealmSwift

final class ChatRoomMessage: Object {
    @Persisted(primaryKey: true) var chatId: String
    @Persisted var roomId: String
    @Persisted var content: String?
    @Persisted var createdAt: String
    @Persisted var sender: User?
    @Persisted var files: List<String>
    
    @Persisted(originProperty: "messages") var chatRoom: LinkingObjects<ChatRoom>

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
