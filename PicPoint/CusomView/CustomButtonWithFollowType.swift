//
//  CustomButtonWithFollowType.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/30/24.
//

import UIKit

class CustomButtonWithFollowType: UIButton {
    enum FollowType {
        case following
        case unfollowing
        case none
    }
    
    var followType: FollowType = .none

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


