//
//  DetailRelatedContentsCollectionViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/19/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class DetailRelatedContentsCollectionViewCell: BaseCollectionViewCell {
    
    let postCustomView = PostCustomView()
    
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
    
    func updateForthSectionDatas(_ cellData: Post) {
        postCustomView.titleLabel.text = cellData.title
        
        let url = URL(string: APIKeys.baseURL + "/\(cellData.files[0])")
        let placeholderImage = UIImage(systemName: "photo")
        postCustomView.photoImageView.kf.setImageWithAuthHeaders(with: url, placeholder: placeholderImage)
        if let shortAddress = cellData.content1?.components(separatedBy: "/")[3] {
            postCustomView.addressLabel.text = shortAddress
        }
    }
}

extension DetailRelatedContentsCollectionViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        
        contentView.addSubview(postCustomView)
        
        postCustomView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
}
