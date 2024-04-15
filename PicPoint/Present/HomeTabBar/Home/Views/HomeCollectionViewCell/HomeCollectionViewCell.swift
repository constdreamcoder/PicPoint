//
//  HomeCollectionViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/15/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeCollectionViewCell: UICollectionViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let topView = HomeCollectionViewCellTopView()
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleToFill
        imageView.tintColor = .darkGray
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    let iconView = HomeCollectionViewCellIconView()
    
    let bottomView = HomeCollectionViewCellBottomView()
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeCollectionViewCell: UICollectionViewCellConfiguration {
    func configureConstraints() {
       
        [
            topView,
            photoImageView,
            iconView,
            bottomView
        ].forEach { containerView.addSubview($0) }
        
        topView.snp.makeConstraints {
            $0.height.equalTo(56.0)
            $0.top.horizontalEdges.equalTo(containerView)
        }
        
        photoImageView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.width.equalTo(containerView)
            $0.height.equalTo(containerView.snp.width).multipliedBy(1.2)
        }
        
        iconView.snp.makeConstraints {
            $0.top.equalTo(photoImageView.snp.bottom)
            $0.height.equalTo(52.0)
            $0.horizontalEdges.equalTo(containerView)
        }
        
        bottomView.snp.makeConstraints {
            $0.top.equalTo(iconView.snp.bottom)
            $0.bottom.horizontalEdges.equalTo(containerView)
        }
        
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(32.0)
            $0.horizontalEdges.equalToSuperview().inset(16.0)
        }
    }
    
    func configureUI() {
        containerView.layer.cornerRadius = 16.0
        
        topView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        topView.layer.cornerRadius = 16.0
        topView.layer.masksToBounds = true
    }
    
    func bind() {
        
    }
}


