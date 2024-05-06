//
//  SelectedPlaceDetailsCollectionViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/6/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SelectedPlaceDetailsCollectionViewCell: BaseCollectionViewCell {
    
    let photoImageView = PhotoImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .brown
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SelectedPlaceDetailsCollectionViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        
        contentView.addSubview(photoImageView)
        
        photoImageView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
    }
}
