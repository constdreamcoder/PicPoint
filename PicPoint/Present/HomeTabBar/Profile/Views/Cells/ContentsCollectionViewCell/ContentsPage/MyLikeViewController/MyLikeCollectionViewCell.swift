//
//  MyLIkeCollectionViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/26/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyLikeCollectionViewCell: BaseCollectionViewCell {
    
    let postCustomView: PostCustomView = {
        let view = PostCustomView()
        view.titleLabel.font = .systemFont(ofSize: 14.0, weight: .bold)
        view.titleLabel.numberOfLines = 1
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCellData(_ post: Post) {
        if post.files.count > 0 {
            let url = URL(string: APIKeys.baseURL + "/\(post.files[0])")
            let placeholderImage = UIImage(systemName: "photo")
            postCustomView.photoImageView.kf.setImageWithAuthHeaders(with: url, placeholder: placeholderImage)
        }
        
        postCustomView.titleLabel.text = post.title
        if let shortAddress = post.content1?.components(separatedBy: "/")[3] {
            postCustomView.addressLabel.text = shortAddress
        }
    }
}

extension MyLikeCollectionViewCell {
    override func configureConstraints() {
        super.configureConstraints()
    
        contentView.addSubview(postCustomView)
        
        postCustomView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        postCustomView.photoImageView.snp.updateConstraints {
            $0.height.equalTo(180.0)
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
}
