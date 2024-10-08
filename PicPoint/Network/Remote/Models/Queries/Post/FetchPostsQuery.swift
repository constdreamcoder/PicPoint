//
//  FetchPostsQuery.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/16/24.
//

import Foundation

struct FetchPostsQuery {
    let next: String?
    let limit: String?
    let product_id: String?
    
    init(
        next: String? = "",
        limit: String? = "",
        product_id: String? = APIKeys.productId
    ) {
        self.next = next
        self.limit = limit
        self.product_id = product_id
    }
}
