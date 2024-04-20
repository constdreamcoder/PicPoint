//
//  CommentProfilView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/20/24.
//

import UIKit
import SnapKit

final class CommentProfileView: UIView {

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
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "서울시 창동"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16.0)
        label.numberOfLines = 0
        return label
    }()
    
    let agoLabel: UILabel = {
        let label = UILabel()
        label.text = "22시간 전"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()
    
    private let profileImageViewWidth: CGFloat = 32.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CommentProfileView: UIViewConfiguration {
    func configureConstraints() {
        [
            profileImageView,
            userNicknameLabel,
            agoLabel,
            subTitleLabel
        ].forEach { addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16.0)
            $0.leading.equalToSuperview().offset(8.0)
            $0.size.equalTo(profileImageViewWidth)
        }
        
        userNicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8.0)
        }
        
        userNicknameLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        agoLabel.snp.makeConstraints {
            $0.centerY.equalTo(userNicknameLabel)
            $0.leading.equalTo(userNicknameLabel.snp.trailing).offset(4.0)
            $0.trailing.equalToSuperview().inset(8.0)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(userNicknameLabel.snp.bottom).offset(4.0)
            $0.leading.equalTo(userNicknameLabel)
            $0.trailing.equalToSuperview().inset(24.0)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configureUI() {
        backgroundColor = .white
    }
}
