//
//  SettingTableViewCellType.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/8/24.
//

import Foundation

enum SettingTableViewCellType: Int, CaseIterable {
    case donationDetailsCell = 0
    case myChatRoomListCell = 1
    
    var index: Int {
        switch self {
        case .donationDetailsCell, .myChatRoomListCell:
            return self.rawValue
        }
    }
    
    var title: String {
        switch self {
        case .donationDetailsCell:
            return "후원내역 확인"
        case .myChatRoomListCell:
            return "내 채팅 목록"
        }
    }
}
