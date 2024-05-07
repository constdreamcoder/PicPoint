//
//  ValidatePaymentModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/4/24.
//

import Foundation

struct ValidatePaymentModel: Decodable {
    let paymentId: String
    let buyerId: String
    let postId: String
    let merchant_uid: String
    let productName: String
    let price: Int
    let paidAt: String
    
    enum CodingKeys: String, CodingKey {
        case paymentId = "payment_id"
        case buyerId = "buyer_id"
        case postId = "post_id"
        case merchant_uid
        case productName
        case price
        case paidAt
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.paymentId = try container.decode(String.self, forKey: .paymentId)
        self.buyerId = try container.decode(String.self, forKey: .buyerId)
        self.postId = try container.decode(String.self, forKey: .postId)
        self.merchant_uid = try container.decode(String.self, forKey: .merchant_uid)
        self.productName = try container.decode(String.self, forKey: .productName)
        self.price = try container.decode(Int.self, forKey: .price)
        self.paidAt = try container.decode(String.self, forKey: .paidAt)
    }
}
