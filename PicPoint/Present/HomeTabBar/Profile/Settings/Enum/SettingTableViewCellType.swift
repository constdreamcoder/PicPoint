//
//  SettingTableViewCellType.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/8/24.
//

import Foundation

enum SettingTableViewCellType: Int, CaseIterable {
    case donationDetailsCell = 0
    
    var index: Int {
        switch self {
        case .donationDetailsCell:
            return self.rawValue
        }
    }
}
