//
//  HomeCollectionViewCellTopView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/15/24.
//

import UIKit
import SnapKit

final class HomeCollectionViewCellTopView: UIView {
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .black
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let userNicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "잠은 죽어서 자자"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16.0, weight: .bold)
        return label
    }()
    
    let placeAddressLabel: UILabel = {
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
            placeAddressLabel
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    let otherSettingsButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        let image = UIImage(systemName: "ellipsis")
        button.setImage(image, for: .normal)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 24)
        button.setPreferredSymbolConfiguration(symbolConfig, forImageIn: .normal)
        return button
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

extension HomeCollectionViewCellTopView: UIViewConfiguration {
    func configureConstraints() {
        [
            profileImageView,
            profileInfoStackView,
            otherSettingsButton,
        ].forEach { addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(40.0)
            $0.leading.equalTo(8.0)
        }
        
        profileInfoStackView.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8.0)
            $0.trailing.equalTo(otherSettingsButton.snp.leading).offset(-16.0)
        }
        
        otherSettingsButton.snp.makeConstraints {
            $0.centerY.equalTo(profileInfoStackView)
            $0.trailing.equalToSuperview().inset(16.0)
        }
        
        otherSettingsButton.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    func configureUI() {
        backgroundColor = .white
    }
}
