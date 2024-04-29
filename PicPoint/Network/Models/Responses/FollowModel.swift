//
//  FollowModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/29/24.
//

import Foundation

struct FollowModel: Decodable {
    let nick: String
    let opponentNick: String
    let followingStatus: Bool
    
    enum CodingKeys: String, CodingKey {
        case nick
        case opponentNick = "opponent_nick"
        case followingStatus = "following_status"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.nick = try container.decode(String.self, forKey: .nick)
        self.opponentNick = try container.decode(String.self, forKey: .opponentNick)
        self.followingStatus = try container.decode(Bool.self, forKey: .followingStatus)
    }
}
