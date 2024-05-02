//
//  Error+Extensions.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/2/24.
//

import Foundation

extension Error {
    var errorCode: Int {
        return Int(self.localizedDescription.components(separatedBy: "/")[0]) ?? 0
    }
    
    var errorDesc: String {
        return self.localizedDescription.components(separatedBy: "/")[1]
    }
}
