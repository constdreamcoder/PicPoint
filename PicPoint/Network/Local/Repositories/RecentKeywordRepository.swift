//
//  RecentKeywordRepository.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/24/24.
//

import Foundation
import RealmSwift

final class RecentKeywordRepository: RepositoryType {
    typealias T = RecentKeyword
    
    static let shared = RecentKeywordRepository()
    
    var realm: Realm {
        return try! Realm()
    }
    
    private init() { }
}
