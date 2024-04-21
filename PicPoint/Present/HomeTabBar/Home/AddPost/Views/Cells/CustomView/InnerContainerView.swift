//
//  InnerContainerView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/21/24.
//

import UIKit
import SnapKit

final class InnerContainerView: UIView {
    
    let leftLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        return label
    }()
    
    let chevronButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = .zero
        configuration.image = UIImage(systemName: "chevron.right")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 16)
        configuration.preferredSymbolConfigurationForImage = symbolConfig
        button.configuration = configuration
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

extension InnerContainerView: UIViewConfiguration {
    func configureConstraints() {
        [
            leftLabel,
            chevronButton
        ].forEach { addSubview($0) }
        
        leftLabel.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview().inset(16.0)
        }
        
        chevronButton.snp.makeConstraints {
            $0.centerY.equalTo(leftLabel)
            $0.trailing.equalToSuperview().inset(16.0)
        }
    }
    
    func configureUI() {
        backgroundColor = .white
    }
}
