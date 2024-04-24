//
//  CLPlacemark+Extensions.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/24/24.
//

import CoreLocation

extension CLPlacemark {
    var fullAddress: String {
        "\(self.country ?? "") \(self.administrativeArea ?? "") \(self.locality ?? "") \(self.subLocality ?? "") \(self.thoroughfare ?? "") \(self.subThoroughfare ?? "")"
    }
    
    var shortAddress: String {
        // 시/도 정보와 도시 정보가 동일한 경우 예외 처리
        if self.administrativeArea == self.locality {
            return "\(self.locality ?? "") \(self.subLocality ?? "")"
        } else {
            return "\(self.administrativeArea ?? "") \(self.locality ?? "") \(self.subLocality ?? "")"
        }
    }
}
