//
//  RecentKeyword.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/11/24.
//

import Foundation
import RealmSwift

final class RecentKeyword: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var keyword: String
    @Persisted var regDate: Date
    
    convenience init(id: String, keyword: String) {
        self.init()
        
        self.id = id
        self.keyword = keyword
        self.regDate = Date()
    }
}
