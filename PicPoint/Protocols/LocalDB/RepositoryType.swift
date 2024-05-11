//
//  RepositoryType.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/11/24.
//

import Foundation
import RealmSwift

protocol RepositoryType {
    func getLocationOfDefaultRealm()
    func read<T: Object>(_ object: T.Type) -> Results<T>
    func write<T: Object>(_ object: T)
    func delete<T: Object>(_ object: T)
    func deleteAll()
}
