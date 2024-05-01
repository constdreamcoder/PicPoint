//
//  LikeModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/30/24.
//

import Foundation

struct LikeModel: Decodable {
    let likeStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case likeStatus = "like_status"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.likeStatus = try container.decode(Bool.self, forKey: .likeStatus)
    }
}
