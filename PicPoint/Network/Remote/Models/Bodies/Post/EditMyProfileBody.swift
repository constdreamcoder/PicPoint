//
//  EditMyProfileBody.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/28/24.
//

import Foundation

struct EditMyProfileBody {
    let nick: String
    let phoneNum: String
    let birthDay: String
    let profileImage: ImageFile
    
    enum Key {
        static let nick = "nick"
        static let phoneNum = "phoneNum"
        static let birthDay = "birthDay"
        static let profileImage = "profile"
    }
}

