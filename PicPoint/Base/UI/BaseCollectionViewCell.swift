//
//  BaseCollectionViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/17/24.
//

import UIKit
import RxSwift

class BaseCollectionViewCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BaseCollectionViewCell: UICollectionViewCellConfiguration {
    func configureConstraints() {
        
    }
    
    func configureUI() {
        backgroundColor = .white
        contentView.backgroundColor = .white
    }
}
