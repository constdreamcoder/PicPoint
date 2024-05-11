//
//  FetchOtherProfileModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/2/24.
//

import Foundation

struct FetchOtherProfileModel: Decodable {
    let userId: String
    let nick: String
    let profileImage: String?
    let followers: [Follower]
    let following: [Following]
    let posts: [String]
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
        case followers
        case following
        case posts
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.nick = try container.decode(String.self, forKey: .nick)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage) ?? ""
        self.followers = try container.decode([Follower].self, forKey: .followers)
        self.following = try container.decode([Following].self, forKey: .following)
        self.posts = try container.decode([String].self, forKey: .posts)
    }
}
