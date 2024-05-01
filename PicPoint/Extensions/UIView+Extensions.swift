//
//  UIView+Extensions.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/30/24.
//

import UIKit

extension UIView {
    func updateFollowButtonUI(_ button: UIButton, with followingStatus: Bool) {
        
        if followingStatus {
            button.configuration?.baseBackgroundColor = .white
            button.configuration?.baseForegroundColor = .black
            button.configuration?.title = "언팔로우"
            button.layer.borderWidth = 1.0
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.cornerRadius = 16
        } else {
            button.configuration?.baseBackgroundColor = .black
            button.configuration?.baseForegroundColor = .white
            button.configuration?.title = "팔로우"
            button.layer.borderWidth = 0.0
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.cornerRadius = 16
        }
    }
}
