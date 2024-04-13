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
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
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
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(32.0)
            $0.horizontalEdges.equalToSuperview().inset(16.0)
        }
    }
    
    private func configureUI() {
    }
    
}
