//
//  MyPostCollectionViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/26/24.
//

import UIKit
import SnapKit

final class MyPostCollectionViewCell: BaseCollectionViewCell {
    
    let postCustomView: PostCustomView = {
        let view = PostCustomView()
        view.titleLabel.font = .systemFont(ofSize: 14.0, weight: .bold)
        view.titleLabel.numberOfLines = 1
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .brown
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyPostCollectionViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        
//        contentView.addSubview(postCustomView)
//        
//        postCustomView.snp.makeConstraints {
//            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
//        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
}
