//
//  FetchMyLikesModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/27/24.
//

import Foundation

struct FetchMyLikesModel: Decodable {
    let data: [Post]
    let nextCursor: String?
    
    enum CodingKeys: String, CodingKey {
        case data
        case nextCursor = "next_cursor"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode([Post].self, forKey: .data)
        self.nextCursor = try container.decodeIfPresent(String.self, forKey: .nextCursor) ?? ""
    }
}
