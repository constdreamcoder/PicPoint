//
//  CommentWritingSectionView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/20/24.
//

import UIKit
import SnapKit

final class CommentWritingSectionView: UIView {
    
    let sendImageButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(systemName: "camera")
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .black
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24.0)
        button.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
        return button
    }()
    
    lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.text = textViewPlaceHolder
        textView.textColor = .lightGray
        textView.font = .systemFont(ofSize: 16.0)
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.black.withAlphaComponent(0.6).cgColor
        textView.layer.cornerRadius = 16.0
        textView.contentInset = .init(top: 0, left: 8, bottom: 0, right: 0)
        textView.textContainerInset = .init(top: 8, left: 0, bottom: 8, right: 8)
        return textView
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = .black
        buttonConfiguration.baseForegroundColor = .white
        buttonConfiguration.buttonSize = .medium
        buttonConfiguration.title = "전송"
        button.configuration = buttonConfiguration
        button.isEnabled = false
        return button
    }()
    
    var textViewPlaceHolder: String

    init(_ textViewPlaceHolder: String = "댓글을 작성해주세요") {
        
        self.textViewPlaceHolder = textViewPlaceHolder
        
        super.init(frame: .zero)

        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CommentWritingSectionView: UIViewConfiguration {
    func configureConstraints() {
        [
            sendImageButton,
            commentTextView,
            sendButton
        ].forEach { addSubview($0) }
        
        sendImageButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8.0)
            $0.centerY.equalTo(sendButton)
        }
        
        commentTextView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.0)
            $0.leading.equalTo(sendImageButton.snp.trailing).offset(8.0)
            $0.bottom.equalToSuperview().inset(16.0)
            $0.trailing.equalTo(sendButton.snp.leading).offset(-8.0)
            $0.height.equalTo(34.0)
        }
        
        sendButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8.0)
            $0.bottom.equalTo(commentTextView)
            $0.width.equalTo(54.0)
            $0.height.equalTo(34.0)
        }
    }
    
    func configureUI() {
        backgroundColor = .white
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowRadius = 2.0
        layer.shadowOpacity = 0.1
    }
}
