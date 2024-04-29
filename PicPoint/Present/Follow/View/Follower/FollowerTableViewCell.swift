//
//  FollowerTableViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/29/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FollowerTableViewCell: CustomFollowTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FollowerTableViewCell {
    override func configureUI() {
        super.configureUI()

        let rightButton = profileContainerView.rightButton
        
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = .white
        buttonConfiguration.baseForegroundColor = .black
        buttonConfiguration.buttonSize = .small
        buttonConfiguration.title = "언팔로우"
        rightButton.configuration = buttonConfiguration
        rightButton.layer.borderWidth = 1.0
        rightButton.layer.borderColor = UIColor.black.cgColor
        rightButton.layer.cornerRadius = 14
    }
}
