//
//  RowView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/25/24.
//

import UIKit
import SnapKit

final class RowView: UIView {
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16.0)
        label.numberOfLines = 2
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RowView: UIViewConfiguration {
    func configureConstraints() {
        [
            iconImageView,
            contentLabel
        ].forEach { addSubview($0) }
        
        iconImageView.snp.makeConstraints {
            $0.size.equalTo(18.0)
            $0.top.leading.bottom.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(8.0)
            $0.centerY.equalTo(iconImageView)
            $0.trailing.equalToSuperview()
        }
    }
    
    func configureUI() {
        backgroundColor = .white
    }
}
