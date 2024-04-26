//
//  FollowerFollowingStackView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/25/24.
//

import UIKit

final class FollowerFollowingStackView: UIStackView {
    
    let followerLabel: UILabel = {
        let label = UILabel()
        label.text = "팔로워"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()
    
    let followerNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "483"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        return label
    }()
    
    let separatorLabel: UILabel = {
        let label = UILabel()
        label.text = "|"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        label.text = "팔로잉"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()
    
    let followingNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "234"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14.0, weight: .bold)
        return label
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
        configureUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        [
            followerLabel,
            followerNumberLabel,
            separatorLabel,
            followingLabel,
            followingNumberLabel
        ].forEach { addArrangedSubview($0) }
    }
    
    private func configureUI() {
        axis = .horizontal
        distribution = .equalSpacing
        spacing = 6.0
    }
}
