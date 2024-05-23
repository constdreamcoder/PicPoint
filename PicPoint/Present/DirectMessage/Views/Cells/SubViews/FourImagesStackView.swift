//
//  FourImagesStackView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/22/24.
//

import UIKit
import SnapKit

final class FourImagesStackView: UIStackView {
    
    let firstImageStackView = TwoImagesStackView()
    let secondImageStackView = TwoImagesStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        [
            firstImageStackView,
            secondImageStackView,
        ].forEach { addArrangedSubview($0) }
    }
    
    private func configureUI() {
        axis = .vertical
        spacing = 1.0
        distribution = .fillEqually
    }
    
    func updateImages(_ imageFiles: [String]) {
        if imageFiles.count > 0 {
            firstImageStackView.updateImages(imageFiles[0...1].map { $0 })
            secondImageStackView.updateImages(imageFiles[2...3].map { $0 })
        }
    }
}
