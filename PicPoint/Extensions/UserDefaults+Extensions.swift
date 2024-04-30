//
//  UserDefaults+Extensions.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/14/24.
//

import Foundation

extension UserDefaults {
    enum Keys: String, CaseIterable {
        case userId
        case email
        case nick
        case accessToken
        case refreshToken
        case accessTokenDueDate
        case refreshTokenDueDate
        case followers
        case followings
    }
    
    func clearAllData() {
        Keys.allCases.forEach { UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
        print("UserDefaults 데이터 모두 삭제")
    }
}

extension UserDefaults {
    var userId: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.userId.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(
                newValue,
                forKey: Keys.userId.rawValue
            )
        }
    }
    
    var email: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.email.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(
                newValue,
                forKey: Keys.email.rawValue
            )
        }
    }
    
    var nick: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.nick.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(
                newValue,
                forKey: Keys.nick.rawValue
            )
        }
    }
    
    var accessToken: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.accessToken.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(
                newValue,
                forKey: Keys.accessToken.rawValue
            )
        }
    }
    
    var refreshToken: String {
        get {
            return UserDefaults.standard.string(forKey: Keys.refreshToken.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.set(
                newValue,
                forKey: Keys.refreshToken.rawValue
            )
        }
    }
    
    var accessTokenDueDate: Date? {
        get {
            let dueDate = UserDefaults.standard.double(forKey: Keys.accessTokenDueDate.rawValue)
            return Date(timeIntervalSince1970: dueDate)
        }
        set {
            UserDefaults.standard.set(
                newValue?.timeIntervalSince1970,
                forKey: Keys.accessTokenDueDate.rawValue
            )
        }
    }
    
    var refreshTokenDueDate: Date? {
        get {
            let dueDate = UserDefaults.standard.double(forKey: Keys.refreshTokenDueDate.rawValue)
            return Date(timeIntervalSince1970: dueDate)
        }
        set {
            UserDefaults.standard.set(
                newValue?.timeIntervalSince1970,
                forKey: Keys.refreshTokenDueDate.rawValue
            )
        }
    }
}

// MARK: - Following-Related Methods
extension UserDefaults {
    var followers: [Follower] {
        get {
            guard let data = UserDefaults.standard.data(forKey: UserDefaults.Keys.followers.rawValue),
                  let historyList = try? PropertyListDecoder().decode([Follower].self, from: data) else {
                return []
            }
            return historyList
        }
        set {
            UserDefaults.standard.set(
                try? PropertyListEncoder().encode(newValue),
                forKey: UserDefaults.Keys.followers.rawValue
            )
        }
    }
    
    var followings: [Following] {
        get {
            guard let data = UserDefaults.standard.data(forKey: UserDefaults.Keys.followings.rawValue),
                  let historyList = try? PropertyListDecoder().decode([Following].self, from: data) else {
                return []
            }
            return historyList
        }
        set {
            UserDefaults.standard.set(
                try? PropertyListEncoder().encode(newValue),
                forKey: UserDefaults.Keys.followings.rawValue
            )
        }
    }
    
}

