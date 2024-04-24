//
//  WritePostBody.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/24/24.
//

import Foundation

struct WritePostBody: Encodable {
    let title: String
    let content: String
    let content1: String
    let content2: String
    let content3: String
    let content4: String
    let content5: String
    let product_id: String
    let files: [String]
    
    init(
        title: String = "",
        content: String = "",
        content1: String = "",
        content2: String = "",
        content3: String = "",
        content4: String = "",
        content5: String = "",
        product_id: String = "",
        files: [String] = []
    ) {
        self.title = title
        self.content = content
        self.content1 = content1
        self.content2 = content2
        self.content3 = content3
        self.content4 = content4
        self.content5 = content5
        self.product_id = product_id
        self.files = files
    }
}
