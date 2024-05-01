//
//  FollowingTableViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/29/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FollowingTableViewCell: CustomFollowTableViewCell {
    
    weak var followingViewModel: FollowingViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    func updateCellData(_ followingCellData: FollowingCellType) {
        if let profileImage = followingCellData.following.profileImage, !profileImage.isEmpty {
            let url = URL(string: APIKeys.baseURL + "/\(profileImage)")
            let placeholderImage = UIImage(systemName: "person.circle")
            profileContainerView.profileImageView.kf.setImageWithAuthHeaders(with: url, placeholder: placeholderImage)
        }
        
        profileContainerView.userNicknameLabel.text = followingCellData.following.nick

        updateFollowButtonUI(
            profileContainerView.rightButton,
            with: followingCellData.followType == .following ? true : false
        )
    }
}

extension FollowingTableViewCell {
    override func configureUI() {
        super.configureUI()
        
        let rightButton = profileContainerView.rightButton
    
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = .black
        buttonConfiguration.baseForegroundColor = .white
        buttonConfiguration.buttonSize = .small
        buttonConfiguration.title = "팔로우"
        rightButton.configuration = buttonConfiguration
    }
    
    func bind(_ followingCellData: FollowingCellType) {
        
        let followButton = profileContainerView.rightButton
        
        followButton.rx.tap
            .bind(with: self) { owner, _ in
                guard let followingViewModel = owner.followingViewModel else { return }
                followingViewModel.selectedFollowingSubject.onNext(followingCellData)
            }
            .disposed(by: disposeBag)
    }
}
