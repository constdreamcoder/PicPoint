//
//  SelectImageInnerCollectionViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/21/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SelectImageInnerCollectionViewCell: BaseCollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}

extension SelectImageInnerCollectionViewCell {
    override func configureConstraints() {
        super.configureConstraints()
    }
    
    override func configureUI() {
        super.configureUI()
        
        contentView.backgroundColor = .brown
    }
}
