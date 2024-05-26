//
//  ChatRoomRepository.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/24/24.
//

import Foundation
import RealmSwift

final class ChatRoomRepository: RepositoryType {
    typealias T = ChatRoom
    
    static let shared = ChatRoomRepository()
    
    var realm: Realm {
        return try! Realm()
    }
    
    private init() {}
    
    func readMessages(_ roomId: String) -> [ChatRoomMessage] {
        let chatRoom = read().where { $0.roomId == roomId }
        return chatRoom[0].messages.map { $0 }
    }
    
    func appendNewRecentChat(_ chattingMessage: ChatRoomMessage) {
        let chatRoom = read().where { $0.roomId == chattingMessage.roomId }

        do {
            try realm.write {
                chatRoom[0].messages.append(chattingMessage)
            }
        } catch {
            print(error)
        }
    }
    
    func appendNewRecentChattingList(_ roomId: String, chattingList: [ChatRoomMessage]) {
        let chatRoom = read().where { $0.roomId == roomId }
        
        do {
            try realm.write {
                chatRoom[0].messages.append(objectsIn: chattingList)
            }
        } catch {
            print(error)
        }
    }
    
    func updateChatRoomList(_ chatRoomList: [T]) {
        do {
            try realm.write {
                realm.add(chatRoomList, update: .modified)
            }
        } catch {
            print(error)
        }
    }
    
    func updateLastChat(_ lastChat: LastChatMessage, chatRoom: ChatRoom) {

        do {
            try realm.write {
                chatRoom.updatedAt = lastChat.createdAt
                chatRoom.lastChat = lastChat
            }
        } catch {
            print(error)
        }
    }
    
}
