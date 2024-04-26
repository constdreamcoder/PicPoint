//
//  ProfileCollectionViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/25/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProfileCollectionViewCell: BaseCollectionViewCell {
    
    let profileImageView: ProfileImageView = {
        let imageView = ProfileImageView(frame: .zero)
        imageView.profileImageViewWidth = 72.0
        return imageView
    }()
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "잠은 죽어서 자자"
        label.textColor = .black
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        return label
    }()
    
    let followerFollowingStackView = FollowerFollowingStackView()
    
    lazy var profileInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        [
            nicknameLabel,
            followerFollowingStackView
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    let bottomButton: UIButton = {
        let button = UIButton()
        button.setTitle("프로필 편집", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .semibold)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ProfileCollectionViewCell {
    
    override func configureConstraints() {
        super.configureConstraints()
        
        [
            profileImageView,
            profileInfoStackView,
            bottomButton
        ].forEach { contentView.addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(profileImageView.profileImageViewWidth)
            $0.top.leading.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
        
        profileInfoStackView.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16.0)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.width.equalTo(profileInfoStackView)
        }
        
        bottomButton.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16.0)
            $0.horizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
    }
}
