//
//  Int+Extensions.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/8/24.
//

import Foundation

extension Int {
    var numberDecimalFormat: String {
        let number = 1000
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: number)) ?? ""
    }
}
