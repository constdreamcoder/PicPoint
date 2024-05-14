//
//  BaseDefaults.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/14/24.
//

import Foundation

@propertyWrapper
struct BaseDefaults<T: Codable> {
    let key: String
    let defaultValue: T
    let isDate: Bool
    let isData: Bool
    let storage: UserDefaults = UserDefaults.standard
    
    init(
        key: String, 
        defaultValue: T,
        isDate: Bool = false,
        isData: Bool = false
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.isDate = isDate
        self.isData = isData
    }
    
    var wrappedValue: T {
        get {
            if isData {
                guard let data = storage.data(forKey: key),
                      let dataList = try? PropertyListDecoder().decode(T.self, from: data) else {
                    return defaultValue
                }
                return dataList
            } else if isDate {
                let dueDate = UserDefaults.standard.double(forKey: key)
                return Date(timeIntervalSince1970: dueDate) as? T ?? defaultValue
            } else {
                return storage.object(forKey: key) as? T ?? defaultValue
            }
        }
        set {
            if isData {
                storage.set(
                    try? PropertyListEncoder().encode(newValue),
                    forKey: key
                )
            } else if isDate {
                guard let newValue = newValue as? Date else { return }
                storage.set(
                    newValue.timeIntervalSince1970,
                    forKey: key
                )
            } else {
                storage.set(newValue, forKey: key)
            }
        }
    }
}

enum UserDefaultsManager {
    enum Key: String, CaseIterable {
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
    
    static func clearAllData() {
        Key.allCases.forEach { UserDefaults.standard.removeObject(forKey: $0.rawValue) }
        print("UserDefaults 데이터 모두 삭제")
    }
}

extension UserDefaultsManager {
    
    @BaseDefaults(key: Key.userId.rawValue, defaultValue: "")
    static var userId
    
    @BaseDefaults(key: Key.email.rawValue, defaultValue: "")
    static var email
    
    @BaseDefaults(key: Key.nick.rawValue, defaultValue: "")
    static var nick
    
    @BaseDefaults(key: Key.accessToken.rawValue, defaultValue: "")
    static var accessToken
    
    @BaseDefaults(key: Key.refreshToken.rawValue, defaultValue: "")
    static var refreshToken
    
    @BaseDefaults(key: Key.accessTokenDueDate.rawValue, defaultValue: Date(), isDate: true)
    static var accessTokenDueDate
    
    @BaseDefaults(key: Key.refreshTokenDueDate.rawValue, defaultValue: Date(), isDate: true)
    static var refreshTokenDueDate
}

extension UserDefaultsManager {
    @BaseDefaults(key: Key.followers.rawValue, defaultValue: [Follower](), isData: true)
    static var followers
    
    @BaseDefaults(key: Key.followings.rawValue, defaultValue: [Following](), isData: true)
    static var followings
}
