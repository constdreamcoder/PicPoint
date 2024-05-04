//
//  HomeCollectionViewCellBottomView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/15/24.
//

import UIKit
import SnapKit

final class HomeCollectionViewCellBottomView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "컨텐츠제목입니다~~"
        label.textColor = .white
        label.font = .systemFont(ofSize: 24.0, weight: .semibold)
        label.numberOfLines = 1
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "컨텐츠 내용 영역입니다영역입니다영역입니다영역입니다영역입니다영역입니다영역입니다영역입니다~~~~~~~~~"
        label.textColor = .white
        label.font = .systemFont(ofSize: 18.0)
        label.numberOfLines = 1
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

extension HomeCollectionViewCellBottomView: UIViewConfiguration {
    func configureConstraints() {
        [
            titleLabel,
            contentLabel
        ].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16.0)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.lessThanOrEqualTo(titleLabel.snp.bottom).offset(8.0)
            $0.horizontalEdges.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview().inset(12.0)
        }
    }
    
    func configureUI() {
        
    }
}
