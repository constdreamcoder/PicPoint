//
//  OpponentDirectMessageTableViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/16/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class OpponentDirectMessageTableViewCell: BaseTableViewCell {
        
    let profileImageView: ProfileImageView  = {
        let imageView = ProfileImageView(frame: .zero)
        imageView.profileImageViewWidth = 40.0
        return imageView
    }()
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "라멘 지배자"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()

    let chatBubbleImageView: ChatBubbleImageView = {
        let bubbleImageView = ChatBubbleImageView(frame: .zero)
        bubbleImageView.tintColor = .systemBlue
        return bubbleImageView
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "fseflisjeflijselfijslefijsliejflsiejf"
        label.textColor = .white
        label.font = .systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "오후 12:45"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 12.0)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}

extension OpponentDirectMessageTableViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        [
            profileImageView,
            nicknameLabel,
            chatBubbleImageView,
            dateLabel
        ].forEach { contentView.addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.leading.top.equalTo(contentView.safeAreaLayoutGuide).offset(8.0)
            $0.size.equalTo(profileImageView.profileImageViewWidth)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(4.0)
        }
        
        chatBubbleImageView.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(4.0)
            $0.leading.equalTo(nicknameLabel)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8.0)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(chatBubbleImageView.snp.trailing).offset(4.0)
            $0.bottom.equalTo(chatBubbleImageView)
            $0.trailing.lessThanOrEqualTo(contentView.safeAreaLayoutGuide).inset(32.0)
        }
        
        chatBubbleImageView.addSubview(contentLabel)
        
        contentLabel.snp.makeConstraints {
            $0.edges.equalTo(chatBubbleImageView).inset(12.0)
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    func bind() {
        
    }
}
