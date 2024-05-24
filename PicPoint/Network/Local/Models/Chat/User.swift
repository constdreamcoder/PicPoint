//
//  User.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/24/24.
//

import Foundation
import RealmSwift

final class User: Object {
    @Persisted(primaryKey: true) var userId: String
    @Persisted var nick: String
    @Persisted var profileImage: String?
    
    convenience init(
        userId: String,
        nick: String,
        profileImage: String? = nil
    ) {
        self.init()
        
        self.userId = userId
        self.nick = nick
        self.profileImage = profileImage
    }
}
