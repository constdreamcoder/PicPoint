//
//  CustomFollowTableViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/29/24.
//

import UIKit
import SnapKit

class CustomFollowTableViewCell: BaseTableViewCell {
    
    let profileContainerView: HomeCollectionViewCellTopView = {
        let view = HomeCollectionViewCellTopView()
        
        view.subTitleLabel.isHidden = true
        view.profileImageView.profileImageViewWidth = 40
            
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomFollowTableViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        
        contentView.addSubview(profileContainerView)
        
        profileContainerView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
            $0.height.equalTo(56.0)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
    }
}
