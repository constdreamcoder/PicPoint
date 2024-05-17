//
//  String+Extensions.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/18/24.
//

import Foundation

extension String {
    var convertToISO8601DateType: Date? {
        let inputDateFormatter = ISO8601DateFormatter()
        inputDateFormatter.timeZone = .current
        inputDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return inputDateFormatter.date(from: self) ?? Date()
    }
    
    var convertToDateType: Date? {
        let inputDateFormatter = DateFormatter()
        inputDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return inputDateFormatter.date(from: self) ?? Date()
    }
    
    var getDateString: String {
        let date = self.convertToDateType
        
        guard let date = date else { return "" }
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.locale = Locale(identifier: "ko_KR")
        outputDateFormatter.dateFormat = "yyyy년 M월 d일"
        return outputDateFormatter.string(from: date)
    }
    
    var getChattingDateString: String {
        let date = self.convertToISO8601DateType
        guard let date = date else { return "" }
        
        let outputDateFormatter = DateFormatter()
        outputDateFormatter.locale = Locale(identifier: "ko_KR")
        outputDateFormatter.dateFormat = "a h:mm"
        return outputDateFormatter.string(from: date)
    }
    
    var timeAgoToDisplay: String {
        let date = self.convertToISO8601DateType
        
        guard let date = date else { return "" }
        
        let secondsAgo = Int(Date().timeIntervalSince(date))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        let year = 12 * month
        
        let quotient: Int
        let unit: String
        
        if secondsAgo < minute {
            quotient = secondsAgo
            unit = "초"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
            unit = "분"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
            unit = "시간"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "일"
        } else if secondsAgo < month {
            quotient = secondsAgo / week
            unit = "주"
        } else if secondsAgo < year {
            quotient = secondsAgo / month
            unit = "달"
        } else {
            quotient = secondsAgo / year
            unit = "년"
        }
        
        return "\(quotient)\(unit) 전"
    }
    
    static func convertToStringWithHashtags(_ array: [String]) -> String {
        let result = array.map { "#\($0)" }.joined(separator: " ")
        return result
    }
}
