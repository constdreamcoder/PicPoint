//
//  UIViewConfiguration.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/15/24.
//

import Foundation

@objc protocol UIViewConfiguration {
    func configureConstraints()
    func configureUI()
    @objc optional func configureOtherSettings()
}
