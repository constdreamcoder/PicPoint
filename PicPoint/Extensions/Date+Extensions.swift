//
//  Date+Extensions.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/23/24.
//

import Foundation

extension Date {
    var convertToString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
}
