//
//  UIViewControllerConfiguration.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/13/24.
//

import Foundation

@objc protocol UIViewControllerConfiguration {
    func configureNavigationBar()
    func configureConstraints()
    func configureUI()
    @objc optional func configureOtherSettings()
    func bind()
}
