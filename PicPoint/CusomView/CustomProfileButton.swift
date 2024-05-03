//
//  CustomProfileButton.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/3/24.
//

import UIKit

final class CustomProfileButton: UIButton {
    enum ProfileImageType {
        case myProfile
        case following
        case unfollowing
    }
    
    var imageType: ProfileImageType
    
    init(imageType: ProfileImageType = .myProfile) {
        
        self.imageType = imageType

        super.init(frame: .zero)
        
        configureUI(imageType)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(_ imageType: ProfileImageType) {
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 20.0, weight: .semibold)
        backgroundColor = .black
        layer.cornerRadius = 16
    }
}
