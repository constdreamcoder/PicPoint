//
//  String+Extensions.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/18/24.
//

import Foundation

extension String {
    var getDateString: String {
        let inputDateFormatter = ISO8601DateFormatter()
        inputDateFormatter.timeZone = .current
        inputDateFormatter.formatOptions = [.withFullDate]
        let date = inputDateFormatter.date(from: self)
        
        guard let date = date else { return "" }
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.locale = Locale(identifier: "ko_KR")
        outputDateFormatter.dateFormat = "yyyy년 M월 d일 방문"
        return outputDateFormatter.string(from: date)
    }
}
