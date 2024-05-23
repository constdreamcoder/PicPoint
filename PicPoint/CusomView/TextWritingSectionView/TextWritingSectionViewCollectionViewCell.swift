//
//  TextWritingSectionViewCollectionViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/21/24.
//

import UIKit
import SnapKit

final class TextWritingSectionViewCollectionViewCell: BaseCollectionViewCell {
    
    let imageView = PhotoImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TextWritingSectionViewCollectionViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        imageView.backgroundColor = .brown
    }
}
