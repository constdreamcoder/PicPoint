//
//  SignUpQuery.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/14/24.
//

import Foundation

struct SignUpQuery: Encodable {
    let email: String
    let password: String
    let nick: String
    let phoneNum: String?
    let birthDay: String?
    
    init(
        email: String,
        password: String,
        nick: String,
        phoneNum: String? = "",
        birthDay: String? = ""
    ) {
        self.email = email
        self.password = password
        self.nick = nick
        self.phoneNum = phoneNum
        self.birthDay = birthDay
    }
}
