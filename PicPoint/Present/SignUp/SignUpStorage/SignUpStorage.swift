//
//  SignUpStorage.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/29/24.
//

import Foundation

final class SignUpStorage {
    static let shared = SignUpStorage()
    
    private var _email: String
    private var _password: String
    private var _nickname: String
    private var _phoneNumber: String?
    private var _birthday: String?
    
    private init(
        email: String = "",
        password: String = "",
        nickname: String = "",
        phoneNumber: String? = nil,
        birthday: String? = nil
    ) {
        self._email = email
        self._password = password
        self._nickname = nickname
        self._phoneNumber = phoneNumber
        self._birthday = birthday
    }
    
    func clearAll() {
        _email = ""
        _password = ""
        _nickname = ""
        _phoneNumber = nil
        _birthday = nil
    }
}

extension SignUpStorage {
    var email: String {
        get {
            return _email
        }
        set {
            _email = newValue
        }
    }
    
    var password: String {
        get {
            return _password
        }
        set {
            _password = newValue
        }
    }
    
    var nickname: String {
        get {
            return _nickname
        }
        set {
            _nickname = newValue
        }
    }
    
    var phoneNumber: String? {
        get {
            return _phoneNumber
        }
        set {
            _phoneNumber = newValue
        }
    }
    
    var birthday: String? {
        get {
            return _birthday
        }
        set {
            _birthday = newValue
        }
    }
}
