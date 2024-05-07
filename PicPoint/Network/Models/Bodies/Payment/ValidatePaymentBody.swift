//
//  ValidatePaymentBody.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/4/24.
//

import Foundation

struct ValidatePaymentBody: Codable {
    let imp_uid: String
    let post_id: String
    let productName: String
    let price: Int
    
    
    init(imp_uid: String, post_id: String, productName: String, price: Int) {
        self.imp_uid = imp_uid
        self.post_id = post_id
        self.productName = productName
        self.price = price
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.imp_uid = try container.decode(String.self, forKey: .imp_uid)
        self.post_id = try container.decode(String.self, forKey: .post_id)
        self.productName = try container.decode(String.self, forKey: .productName)
        self.price = try container.decode(Int.self, forKey: .price)
    }
    
}
