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
    
    let deleteButton: UIButton = {
        let button = UIButton()
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = .white
        buttonConfiguration.baseForegroundColor = .black
        buttonConfiguration.image = UIImage(systemName: "xmark.circle.fill")
        buttonConfiguration.contentInsets = .zero
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20)
        buttonConfiguration.preferredSymbolConfigurationForImage = symbolConfiguration
        button.configuration = buttonConfiguration
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
        configureUI()
        bind()
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
         [
            photoImageView,
            deleteButton
         ].forEach { contentView.addSubview($0) }
      
        photoImageView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        deleteButton.snp.makeConstraints {
            $0.trailing.equalTo(photoImageView)
            $0.top.equalTo(photoImageView)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
    }
    
    func bind() {
        
    }

}
