//
//  CommentWritingSectionView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/20/24.
//

import UIKit
import SnapKit

final class TextWritingSectionView: UIView {
    
    let addImagesButton: UIButton = {
        let button = UIButton()
        let buttonImage = UIImage(systemName: "plus")
        button.setImage(buttonImage, for: .normal)
        button.tintColor = .black
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 24.0)
        button.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
        button.isHidden = true
        return button
    }()
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = textViewPlaceHolder
        textView.textColor = .lightGray
        textView.font = .systemFont(ofSize: 16.0)
        textView.contentInset = .init(top: 0, left: 8, bottom: 0, right: 0)
        textView.textContainerInset = .init(top: 8, left: 0, bottom: 8, right: 8)
        return textView
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.backgroundColor = .white
        
        collectionView.register(TextWritingSectionViewCollectionViewCell.self, forCellWithReuseIdentifier: TextWritingSectionViewCollectionViewCell.identifier)
        
        collectionView.isScrollEnabled = false
        
        collectionView.isHidden = true
        return collectionView
    }()
    
    lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.layer.borderWidth = 1.0
        stackView.layer.borderColor = UIColor.black.withAlphaComponent(0.6).cgColor
        stackView.layer.cornerRadius = 12.0
        [
            textView,
            collectionView
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateCollectionViewHeight()
    }
}

extension TextWritingSectionView: UIViewConfiguration {
    func configureConstraints() {
        [
            addImagesButton,
            contentStackView,
            sendButton
        ].forEach { addSubview($0) }
        
        addImagesButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8.0)
            $0.centerY.equalTo(sendButton)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8.0)
            $0.leading.equalTo(addImagesButton.snp.trailing).offset(8.0)
            $0.trailing.equalTo(sendButton.snp.leading).offset(-8.0)
            $0.bottom.equalToSuperview().inset(16.0)
        }
        
        textView.snp.makeConstraints {
            $0.height.equalTo(34.0)
        }

        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(0.1)
        }
        
        sendButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(8.0)
            $0.bottom.equalTo(contentStackView)
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
    
    private func updateCollectionViewHeight() {
        collectionView.snp.updateConstraints {
            $0.height.equalTo(collectionView.frame.width / 5)
        }
    }
}

extension TextWritingSectionView: UICollectionViewConfiguration {
    func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(1/5)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        group.interItemSpacing = .fixed(4)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = .init(top: 0, leading: 4, bottom: 0, trailing: 4)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
