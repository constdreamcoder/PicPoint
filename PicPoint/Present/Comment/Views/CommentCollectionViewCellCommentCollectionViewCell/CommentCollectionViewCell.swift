//
//  CommentCollectionViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/20/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class CommentCollectionViewCell: BaseCollectionViewCell {
    
    let commentView = CommentProfileView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CommentCollectionViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        
        [
            commentView
        ].forEach { contentView.addSubview($0) }
        
        commentView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
}
