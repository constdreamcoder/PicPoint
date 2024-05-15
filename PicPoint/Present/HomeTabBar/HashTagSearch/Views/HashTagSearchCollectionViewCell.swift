//
//  HashTagSearchCollectionViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/15/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HashTagSearchCollectionViewCell: BaseCollectionViewCell {
    let thumnailImageView = PhotoImageView(frame: .zero)
    
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

extension HashTagSearchCollectionViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        
        contentView.addSubview(thumnailImageView)
        
        thumnailImageView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    func bind() {
        
    }
}
