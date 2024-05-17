//
//  ChatBubbleImageView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/16/24.
//

import UIKit

final class ChatBubbleImageView: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        let image = UIImage(named: "messageBubble")
        let horizontalInset = (image?.size.width ?? 0.0) * 0.4
        let verticalInset = (image?.size.height ?? 0.0) * 0.4
        self.image = image?.resizableImage(
            withCapInsets: UIEdgeInsets(
                top: verticalInset,
                left: horizontalInset,
                bottom: verticalInset,
                right: horizontalInset),
            resizingMode: .stretch
        ).withRenderingMode(.alwaysTemplate)
    }
}
