//
//  ChatRoomMessageRepository.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/24/24.
//

import Foundation
import RealmSwift

final class ChatRoomMessageRepository: RepositoryType {
    typealias T = ChatRoomMessage

    static let shared = ChatRoomMessageRepository()

    var realm: Realm {
        return try! Realm()
    }
    
    private init() { }
}

