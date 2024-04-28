//
//  CustomBottomButton.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/28/24.
//

import UIKit
import SnapKit

final class CustomBottomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .black
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 16.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.font = .systemFont(ofSize: 18.0, weight: .bold)
        
        self.snp.makeConstraints {
            $0.height.equalTo(50.0)
        }
    }
}
