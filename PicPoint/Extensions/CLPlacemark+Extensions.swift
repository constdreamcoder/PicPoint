//
//  CLPlacemark+Extensions.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/24/24.
//

import CoreLocation

extension CLPlacemark {
    var fullAddress: String {
        if self.administrativeArea == self.locality {
            let fullAddress = "\(self.country ?? "") \(self.administrativeArea ?? "") \(self.subLocality ?? "") \(self.thoroughfare ?? "") \(self.subThoroughfare ?? "")"
            return filterWhitespace(fullAddress).trimmingCharacters(in: .whitespacesAndNewlines)
        } else {
            let fullAddress = "\(self.country ?? "") \(self.administrativeArea ?? "") \(self.locality ?? "") \(self.subLocality ?? "") \(self.thoroughfare ?? "") \(self.subThoroughfare ?? "")"
            return filterWhitespace(fullAddress).trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
    }
    
    var shortAddress: String {
        // 시/도 정보와 도시 정보가 동일한 경우 예외 처리
        if self.administrativeArea == self.locality {
            let shortAddress = "\(self.locality ?? "") \(self.subLocality ?? "")"
            
            return filterWhitespace(shortAddress).trimmingCharacters(in: .whitespacesAndNewlines)

        } else {
            let shortAddress = "\(self.administrativeArea ?? "") \(self.locality ?? "") \(self.subLocality ?? "")"
            
            return filterWhitespace(shortAddress).trimmingCharacters(in: .whitespacesAndNewlines)

        }
    }
    
    func filterWhitespace(_ input: String) -> String {
        // 정규식 패턴을 사용하여 빈칸을 1개로만 유지하고 나머지는 제거
        let pattern = "\\s+"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let replaced = regex.stringByReplacingMatches(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count), withTemplate: " ")
        
        return replaced
    }

}
