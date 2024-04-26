//
//  MyLIkeCollectionViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/26/24.
//

import UIKit

final class MyLikeCollectionViewCell: BaseCollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .blue
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyLikeCollectionViewCell {
    override func configureConstraints() {
        super.configureConstraints()
    }
    
    override func configureUI() {
        super.configureUI()
    }
}
