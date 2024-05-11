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
    let birthDay: String?
    let phoneNum: String?
    let followers: [Follower]
    let followings: [Following]
    let posts: [String]
    
    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case nick
        case profileImage
        case birthDay
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
        self.birthDay = try container.decodeIfPresent(String.self, forKey: .birthDay) ?? ""
        self.phoneNum = try container.decodeIfPresent(String.self, forKey: .phoneNum) ?? ""
        self.followers = try container.decode([Follower].self, forKey: .followers)
        self.followings = try container.decode([Following].self, forKey: .following)
        self.posts = try container.decode([String].self, forKey: .posts)
    }
    
    init(userId: String, email: String, nick: String, profileImage: String?, birthDay: String?, phoneNum: String?, followers: [Follower], followings: [Following], posts: [String]) {
        self.userId = userId
        self.email = email
        self.nick = nick
        self.profileImage = profileImage
        self.birthDay = birthDay
        self.phoneNum = phoneNum
        self.followers = followers
        self.followings = followings
        self.posts = posts
    }
}

struct Follower: Codable {
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

struct Following: Codable {
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
    
    init(userId: String, nick: String, profileImage: String?) {
        self.userId = userId
        self.nick = nick
        self.profileImage = profileImage
    }
}
