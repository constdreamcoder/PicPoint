//
//  SearchCurrentUserLocationError.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/5/24.
//

import Foundation

enum SearchCurrentUserLocationError: Int, LocalizedError {
    case failToSearchLocation = 404
  
    var errorDescription: String? {
        switch self {
        case .failToSearchLocation:
            return "\(self.rawValue)/유저 위치를 찾는데 실패하였습니다."
        }
    }
}
