//
//  TikTokFeedCollectionViewCell.swift
//  TikTokFeedPrac
//
//  Created by SUCHAN CHANG on 4/12/24.
//

import UIKit
import SnapKit

final class TikTokFeedCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: TikTokFeedCollectionViewCell.self)
    
    let testImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
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
    
    private func configureConstraints() {
        contentView.addSubview(testImageView)
        
        testImageView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    private func configureUI() {
        contentView.backgroundColor = .brown
    }
    
}
