//
//  ImageViewCollectionViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/5/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class ImageViewCollectionViewCell: BaseCollectionViewCell {
    let photoImageView = PhotoImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .brown
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        photoImageView.image = UIImage(systemName: "photo")
        disposeBag = DisposeBag()
    }
    
    func updatedCellData(_ file: String) {
        let url = URL(string: APIKeys.baseURL + "/\(file)")
        let placeholderImage = UIImage(systemName: "photo")
        photoImageView.kf.setImageWithAuthHeaders(with: url, placeholder: placeholderImage)
    }
}

extension ImageViewCollectionViewCell {
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
