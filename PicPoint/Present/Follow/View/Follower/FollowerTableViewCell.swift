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
import Kingfisher

final class FollowerTableViewCell: CustomFollowTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}

extension FollowerTableViewCell {
    override func configureUI() {
        super.configureUI()

        profileContainerView.rightButton.isHidden = true
        
//        let rightButton = profileContainerView.rightButton
//        
//        var buttonConfiguration = UIButton.Configuration.filled()
//        buttonConfiguration.baseBackgroundColor = .white
//        buttonConfiguration.baseForegroundColor = .black
//        buttonConfiguration.buttonSize = .small
//        buttonConfiguration.title = "삭제"
//        rightButton.configuration = buttonConfiguration
//        rightButton.layer.borderWidth = 1.0
//        rightButton.layer.borderColor = UIColor.black.cgColor
//        rightButton.layer.cornerRadius = 14
    }
    
    func updateCellData(_ follower: Follower) {
        
        if let profileImage = follower.profileImage, !profileImage.isEmpty {
            let url = URL(string: APIKeys.baseURL + "/\(profileImage)")
            let placeholderImage = UIImage(systemName: "person.circle")
            profileContainerView.profileImageView.kf.setImageWithAuthHeaders(with: url, placeholder: placeholderImage)
        }
        
        profileContainerView.userNicknameLabel.text = follower.nick
    }
}
