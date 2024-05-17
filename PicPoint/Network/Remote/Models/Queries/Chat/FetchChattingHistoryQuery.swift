//
//  FetchChattingHistoryQuery.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/17/24.
//

import Foundation

struct FetchChattingHistoryQuery {
    let cursor_date: String?
    
    init(cursor_date: String? = nil) {
        self.cursor_date = cursor_date
    }
}
