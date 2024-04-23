//
//  Date+Extensions.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/23/24.
//

import Foundation

extension Date {
    var convertToDateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
    
    var convertToTimeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h시 m분"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: self)
    }
}
