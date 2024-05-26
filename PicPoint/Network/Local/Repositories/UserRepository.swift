//
//  UserRepository.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/24/24.
//

import Foundation
import RealmSwift

final class UserRepository: RepositoryType {
    typealias T = User

    static let shared = UserRepository()

    var realm: Realm {
        return try! Realm()
    }
    
    private init() {}
}

