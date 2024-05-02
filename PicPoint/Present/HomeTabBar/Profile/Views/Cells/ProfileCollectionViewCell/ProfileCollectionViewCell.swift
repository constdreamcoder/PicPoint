//
//  ProfileCollectionViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/25/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class ProfileCollectionViewCell: BaseCollectionViewCell {
    
    let profileImageView: ProfileImageView = {
        let imageView = ProfileImageView(frame: .zero)
        imageView.profileImageViewWidth = 72.0
        return imageView
    }()
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "잠은 죽어서 자자"
        label.textColor = .black
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        return label
    }()
    
    let followerFollowingStackView = FollowerFollowingStackView()
    
    lazy var profileInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.distribution = .equalSpacing
        stackView.alignment = .leading
        [
            nicknameLabel,
            followerFollowingStackView
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    let bottomButton: UIButton = {
        let button = UIButton()
        button.setTitle("프로필 수정", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20.0, weight: .semibold)
        button.backgroundColor = .black
        button.layer.cornerRadius = 16
        return button
    }()
    
    private lazy var moveToFollowTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: nil)
        followerFollowingStackView.addGestureRecognizer(tap)
        return tap
    }()
    
    weak var profileViewModel: ProfileViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    deinit {
        followerFollowingStackView.removeGestureRecognizer(moveToFollowTap)
    }
    
}

extension ProfileCollectionViewCell {
    
    override func configureConstraints() {
        super.configureConstraints()
        
        [
            profileImageView,
            profileInfoStackView,
            bottomButton
        ].forEach { contentView.addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(profileImageView.profileImageViewWidth)
            $0.top.leading.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
        
        profileInfoStackView.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16.0)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.width.equalTo(profileInfoStackView)
        }
        
        bottomButton.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16.0)
            $0.horizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
    }
    
    func bind() {
        guard let profileViewModel else { return }
        
        profileViewModel.myProfile.asDriver()
            .drive(with: self) { owner, myProfile in
                guard let myProfile else { return }
                
                if let profileImage = myProfile.profileImage, !profileImage.isEmpty {
                    let url = URL(string: APIKeys.baseURL + "/\(profileImage)")
                    let placeholderImage = UIImage(systemName: "person.circle")
                    owner.profileImageView.kf.setImageWithAuthHeaders(with: url, placeholder: placeholderImage)
                }
                
                owner.nicknameLabel.text = myProfile.nick
                owner.followerFollowingStackView.followerNumberLabel.text = myProfile.followers.count.description
                owner.followerFollowingStackView.followingNumberLabel.text = myProfile.followings.count.description
            }
            .disposed(by: disposeBag)
        
        profileViewModel.updateFollowingsCountRelay.asDriver(onErrorJustReturn: 0)
            .drive(with: self) { owner, updatedFollowingsCount in
                owner.followerFollowingStackView.followingNumberLabel.text = updatedFollowingsCount.description
            }
            .disposed(by: disposeBag)
        
        bottomButton.rx.tap
            .bind(with: self) { owner, _ in
                guard let profileViewModel = owner.profileViewModel else { return }
                profileViewModel.editProfileButtonTap.accept(())
            }
            .disposed(by: disposeBag)
        
        moveToFollowTap.rx.event
            .bind(with: self) { owner, gesture in
                profileViewModel.moveToFollowTap.onNext(())
            }
            .disposed(by: disposeBag)
    }
}
