//
//  SeparatorView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/19/24.
//

import UIKit

final class SeparatorView: UIView {
    
    let height: CGFloat = 1.0

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SeparatorView: UIViewConfiguration {
    func configureConstraints() {
        backgroundColor = .lightGray.withAlphaComponent(0.4)
    }
    
    func configureUI() {
        
    }
}
