//
//  SelectImageInnerCollectionViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/21/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SelectImageInnerCollectionViewCell: BaseCollectionViewCell {
    
    let photoImageView: PhotoImageView = {
        let imageView = PhotoImageView(frame: .zero)
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}

extension SelectImageInnerCollectionViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        
        contentView.addSubview(photoImageView)
        
        photoImageView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        super.configureUI()        
    }
}
