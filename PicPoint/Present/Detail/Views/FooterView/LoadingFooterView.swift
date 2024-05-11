//
//  LoadingFooterView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/11/24.
//

import UIKit
import SnapKit

final class LoadingFooterView: UICollectionReusableView {
    
    let indicatorView = UIActivityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
        configureUI()
        
        indicatorView.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoadingFooterView: UIViewConfiguration {
    func configureConstraints() {
        addSubview(indicatorView)
        
        indicatorView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureUI() {
        
    }
    
    
}
