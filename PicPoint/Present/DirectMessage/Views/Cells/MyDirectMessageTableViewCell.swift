//
//  MyDirectMessageTableViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/16/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyDirectMessageTableViewCell: BaseTableViewCell {
    
    let chatBubbleImageView: ChatBubbleImageView = {
        let bubbleImageView = ChatBubbleImageView(frame: .zero)
        bubbleImageView.tintColor = .systemGray3
        return bubbleImageView
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요안녕하세요"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14.0)
        label.numberOfLines = 0
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "오후 11:45"
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
    
}

extension MyDirectMessageTableViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        
        [
            chatBubbleImageView,
            dateLabel
        ].forEach { contentView.addSubview($0) }
        
        chatBubbleImageView.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(8.0)
            $0.trailing.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8.0)
        }
        
        dateLabel.snp.makeConstraints {
            $0.trailing.equalTo(chatBubbleImageView.snp.leading).offset(-4.0)
            $0.bottom.equalTo(chatBubbleImageView)
            $0.leading.greaterThanOrEqualTo(contentView.safeAreaLayoutGuide).offset(32.0)
        }
        
        chatBubbleImageView.addSubview(contentLabel)
        
        contentLabel.snp.makeConstraints {
            $0.edges.equalTo(chatBubbleImageView).inset(12.0)
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
}
