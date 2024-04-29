//
//  FollowingTableViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/29/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FollowingTableViewCell: CustomFollowTableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FollowingTableViewCell {
    override func configureUI() {
        super.configureUI()
        
        let rightButton = profileContainerView.rightButton
    
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = .black
        buttonConfiguration.baseForegroundColor = .white
        buttonConfiguration.buttonSize = .small
        buttonConfiguration.title = "팔로우"
        rightButton.configuration = buttonConfiguration
    }
}
