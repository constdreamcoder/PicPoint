//
//  InnerTextView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/21/24.
//

import UIKit
import SnapKit

final class InnerTextViewContainerView: UIView {
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 14.0)
        textView.textColor = .lightGray
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        textView.sizeToFit()
        return textView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InnerTextViewContainerView: UIViewConfiguration {
    func configureConstraints() {
        addSubview(textView)
        
        textView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureUI() {
        backgroundColor = .white
    }
}
