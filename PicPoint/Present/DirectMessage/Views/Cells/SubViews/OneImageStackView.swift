//
//  OneImageStackView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/23/24.
//

import UIKit
import SnapKit
import Kingfisher

final class OneImageStackView: UIStackView {

    let imageView = PhotoImageView(frame: .zero)
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func configureConstraints() {
        addArrangedSubview(imageView)
    }
    
    func updateImage(_ imageFiles: [String]) {
        if imageFiles.count > 0 {
            let url = URL(string: APIKeys.baseURL + "/\(imageFiles[0])")
            let placeholderImage = UIImage(systemName: "photo")
            imageView.kf.setImageWithAuthHeaders(with: url, placeholder: placeholderImage)
        }
    }
}
