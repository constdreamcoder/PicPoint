//
//  ThreeImagesStackView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/22/24.
//

import UIKit
import SnapKit

final class ThreeImagesStackView: UIStackView {
    
    let firstImageView: PhotoImageView = {
        let imageView = PhotoImageView(frame: .zero)
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let secondImageView: PhotoImageView = {
        let imageView = PhotoImageView(frame: .zero)
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let thirdImageView: PhotoImageView = {
        let imageView = PhotoImageView(frame: .zero)
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        return imageView
    }()

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
            firstImageView,
            secondImageView,
            thirdImageView
        ].forEach { addArrangedSubview($0) }
    }
    
    private func configureUI() {
        axis = .horizontal
        spacing = 1.0
        distribution = .fillEqually
    }
    
    func updateImages(_ imageFiles: [String]) {
        if imageFiles.count > 0 {
            let placeholderImage = UIImage(systemName: "photo")
            
            let firstImageURL = URL(string: APIKeys.baseURL + "/\(imageFiles[0])")
            firstImageView.kf.setImageWithAuthHeaders(with: firstImageURL, placeholder: placeholderImage)
            
            let secondImageURL = URL(string: APIKeys.baseURL + "/\(imageFiles[1])")
            secondImageView.kf.setImageWithAuthHeaders(with: secondImageURL, placeholder: placeholderImage)
            
            let thirdImageURL = URL(string: APIKeys.baseURL + "/\(imageFiles[2])")
            thirdImageView.kf.setImageWithAuthHeaders(with: thirdImageURL, placeholder: placeholderImage)
            
        }
    }
}
