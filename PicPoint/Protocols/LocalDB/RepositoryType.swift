//
//  RepositoryType.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/11/24.
//

import Foundation
import RealmSwift

protocol RepositoryType {
    associatedtype T: Object
    
    func getLocationOfDefaultRealm()
    func read(_ object: T.Type) -> Results<T>
    func write(_ object: T)
    func delete(_ object: T)
    func deleteAll()
}

extension RepositoryType {
    static var realm: Realm {
        return try! Realm()
    }
}
