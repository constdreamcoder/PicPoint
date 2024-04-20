//
//  IconLablelStackView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/15/24.
//

import UIKit
import SnapKit

final class IconLabelStackView: UIStackView {
    
    let button: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 24)
        button.setPreferredSymbolConfiguration(symbolConfig, forImageIn: .normal)
        return button
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension IconLabelStackView: UIViewConfiguration {
    func configureConstraints() {
        [button, label].forEach { addArrangedSubview($0) }
    }
    
    func configureUI() {
        axis = .horizontal
        spacing = 4.0
    }
}
