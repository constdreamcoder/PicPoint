//
//  SendChatBody.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/18/24.
//

import Foundation

struct SendChatBody: Codable {
    let content: String?
    let files: [String]
    
    enum CodingKeys: CodingKey {
        case content
        case files
    }
    
    init(
        content: String? = nil,
        files: [String] = []
    ) {
        self.content = content
        self.files = files
    }
}
