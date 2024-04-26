//
//  ProfileImageView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/25/24.
//

import UIKit

final class ProfileImageView: UIImageView {
    
    var profileImageViewWidth: CGFloat = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        image = UIImage(systemName: "person.circle")
        tintColor = .black
        contentMode = .scaleToFill
        clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = profileImageViewWidth / 2
    }
}
