//
//  PostCustomCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/26/24.
//

import UIKit
import SnapKit

class PostCustomView: UIView {
    
    let photoImageView = PhotoImageView(frame: .zero)
    
    let heartButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "heart")
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 32)
        button.setPreferredSymbolConfiguration(symbolConfig, forImageIn: .normal)
        button.isHidden = true
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "테스트 타이틀타이틀타이틀 타이틀"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16.0, weight: .bold)
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 2
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "서울 도봉구"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 12.0)
        label.numberOfLines = 1
        return label
    }()
    
    let bottomContainerView: UIView = {
        let view = UIView()
        return view
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

extension PostCustomView: UIViewConfiguration {
    func configureConstraints() {
        
        [
            titleLabel,
            addressLabel
        ].forEach { bottomContainerView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(8.0)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(6.0)
            $0.horizontalEdges.equalToSuperview().inset(8.0)
            $0.bottom.lessThanOrEqualToSuperview().inset(8.0)
        }
        
        [
            photoImageView,
            heartButton,
            bottomContainerView
        ].forEach { addSubview($0) }
        
        photoImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(220)
        }
        
        heartButton.snp.makeConstraints {
            $0.top.trailing.equalTo(photoImageView).inset(16.0)
        }
        
        bottomContainerView.snp.makeConstraints {
            $0.top.equalTo(photoImageView.snp.bottom)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    func configureUI() {
        backgroundColor = .white
    }
}

