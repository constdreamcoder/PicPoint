//
//  SelectImageCollectionReusableView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/22/24.
//

import UIKit
import SnapKit

final class SelectImageCollectionReusableView: UICollectionReusableView {
    
    let photoImageView: PhotoImageView = {
        let imageView = PhotoImageView(frame: .zero)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SelectImageCollectionReusableView: UIViewConfiguration {
    func configureConstraints() {
        addSubview(photoImageView)
        
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureUI() {
        backgroundColor = .white
    }
}
