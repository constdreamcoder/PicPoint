//
//  HomeCollectionViewCellIconView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/15/24.
//

import UIKit
import SnapKit

final class HomeCollectionViewCellIconView: UIView {
    
    let heartStackView: IconLabelStackView = {
        let stackView = IconLabelStackView()
        let buttonImage = UIImage(systemName: "heart")
        stackView.button.setImage(buttonImage, for: .normal)
        stackView.label.text = "256" // TODO: - 999 개 이상일 때 +999 표시
        return stackView
    }()
    
    let commentStackView: IconLabelStackView = {
        let stackView = IconLabelStackView()
        let buttonImage = UIImage(systemName: "bubble")
        stackView.button.setImage(buttonImage, for: .normal)
        stackView.label.text = "55" // TODO: - 999 개 이상일 때 +999 표시
        return stackView
    }()
    
    lazy var leftIconStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 24.0
        [
            heartStackView,
            commentStackView
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "bookmark")
        button.setImage(image, for: .normal)
        button.tintColor = .black
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

extension HomeCollectionViewCellIconView: UIViewConfiguration {
    func configureConstraints() {
        [
            leftIconStackView,
            bookmarkButton
        ].forEach { addSubview($0) }
        
        leftIconStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.0)
            $0.centerY.equalToSuperview()
        }
        
        bookmarkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16.0)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configureUI() {
        
    }
}
