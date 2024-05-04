//
//  ValidatePaymentModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/4/24.
//

import Foundation

struct ValidatePaymentModel: Decodable {
    let imp_uid: String
    let post_id: String
    let productName: String
    let price: Int
}
