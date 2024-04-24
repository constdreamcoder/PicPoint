//
//  DetailLocationCollectionReusableView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/25/24.
//

import UIKit

final class DetailLocationCollectionReusableView: UICollectionReusableView {
    
    let separatorView = SeparatorView()
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "위치정보"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        return  label
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

extension DetailLocationCollectionReusableView: UIViewConfiguration {
    func configureConstraints() {
        [
            separatorView,
            headerLabel
        ].forEach { addSubview($0)}
       
        separatorView.snp.makeConstraints {
            $0.height.equalTo(separatorView.height)
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(16.0)
        }
        
        headerLabel.snp.makeConstraints {
            $0.leading.equalTo(16.0)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configureUI() {
        
    }
}
