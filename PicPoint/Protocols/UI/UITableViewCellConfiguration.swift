//
//  UITableViewCellConfiguration.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/17/24.
//

import Foundation

@objc protocol UITableViewCellConfiguration {
    func confiugreConstraints()
    func configureUI()
    @objc optional func configureOtherSettings()
}
