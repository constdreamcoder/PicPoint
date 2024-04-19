//
//  PhotoImageView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/19/24.
//

import UIKit

final class PhotoImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PhotoImageView: UIViewConfiguration {
    func configureConstraints() {
        
    }
    
    func configureUI() {
        image = UIImage(systemName: "photo")
        contentMode = .scaleToFill
        tintColor = .darkGray
        backgroundColor = .lightGray
    }
}
