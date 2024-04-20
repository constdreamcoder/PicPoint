//
//  HomeCollectionViewCellTopView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/15/24.
//

import UIKit
import SnapKit

final class HomeCollectionViewCellTopView: UIView {
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .black
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = profileImageViewWidth / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userNicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "잠은 죽어서 자자"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16.0, weight: .bold)
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "서울시 창동"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()
    
    lazy var profileInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 2.0
        [
            userNicknameLabel,
            subTitleLabel
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    let rightButton = UIButton()
    
    private let profileImageViewWidth: CGFloat = 40.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeCollectionViewCellTopView: UIViewConfiguration {
    func configureConstraints() {
        [
            profileImageView,
            profileInfoStackView,
            rightButton,
        ].forEach { addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(profileImageViewWidth)
            $0.leading.equalTo(8.0)
        }
        
        profileInfoStackView.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8.0)
            $0.trailing.equalTo(rightButton.snp.leading).offset(-16.0)
        }
        
        rightButton.snp.makeConstraints {
            $0.centerY.equalTo(profileInfoStackView)
            $0.trailing.equalToSuperview().inset(16.0)
        }
        
        rightButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    func configureUI() {
        backgroundColor = .white
    }
}
