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
    
    private init() { }
}