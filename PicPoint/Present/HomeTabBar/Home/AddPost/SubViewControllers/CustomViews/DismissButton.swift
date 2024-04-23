//
//  DismissButton.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/24/24.
//

import UIKit

final class DismissButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = .darkGray
        buttonConfiguration.baseForegroundColor = .lightGray
        buttonConfiguration.image = UIImage(systemName: "xmark.circle.fill")
        buttonConfiguration.contentInsets = .zero
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 22)
        buttonConfiguration.preferredSymbolConfigurationForImage = symbolConfiguration
        configuration = buttonConfiguration
    }
    
}
