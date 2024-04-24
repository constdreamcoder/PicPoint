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
}
