//
//  FetchMyProfileModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/26/24.
//

import Foundation

struct FetchMyProfileModel: Decodable {
    let userId: String
    let email: String
    let nick: String
    let profileImage: String?
    let birthday: String?
    let phoneNum: String?
    let followers: [Follower]
    let following: [Following]
    let posts: [String]
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nick
        case profileImage
        case birthday
        case phoneNum
        case followers
        case following
        case posts
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.email = try container.decode(String.self, forKey: .email)
        self.nick = try container.decode(String.self, forKey: .nick)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage) ?? ""
        self.birthday = try container.decodeIfPresent(String.self, forKey: .birthday) ?? ""
        self.phoneNum = try container.decodeIfPresent(String.self, forKey: .phoneNum) ?? ""
        self.followers = try container.decode([Follower].self, forKey: .followers)
        self.following = try container.decode([Following].self, forKey: .following)
        self.posts = try container.decode([String].self, forKey: .posts)
    }
}

struct Follower: Decodable {
    let userId: String
    let nick: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.nick = try container.decode(String.self, forKey: .nick)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage) ?? ""
    }
}

struct Following: Decodable {
    let userId: String
    let nick: String
    let profileImage: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case nick
        case profileImage
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.userId = try container.decode(String.self, forKey: .userId)
        self.nick = try container.decode(String.self, forKey: .nick)
        self.profileImage = try container.decodeIfPresent(String.self, forKey: .profileImage) ?? ""
    }
}
