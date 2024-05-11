//
//  FetchPostWithHashTagQuery.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/25/24.
//

import Foundation

struct FetchPostWithHashTagQuery {
    let next: String?
    let limit: String?
    let product_id: String?
    let hashTag: String?
    
    init(
        next: String? = "",
        limit: String? = "",
        product_id: String? = APIKeys.productId,
        hashTag: String? = ""
    ) {
        self.next = next
        self.limit = limit
        self.product_id = product_id
        self.hashTag = hashTag
    }
}
