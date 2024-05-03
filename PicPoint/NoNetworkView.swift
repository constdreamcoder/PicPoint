//
//  NoNetworkView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/3/24.
//

import UIKit
import SnapKit

final class NoNetworkView: UIView {
    
    lazy var noWifiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "nowifi")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white.withAlphaComponent(0.8)
        
        addSubview(noWifiImageView)
        
        noWifiImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(300.0)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
