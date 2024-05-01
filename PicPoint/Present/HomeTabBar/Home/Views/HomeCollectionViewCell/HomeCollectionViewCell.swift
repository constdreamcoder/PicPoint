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
import Kingfisher

final class HomeCollectionViewCell: BaseCollectionViewCell {
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let topView: HomeCollectionViewCellTopView = {
        let topView = HomeCollectionViewCellTopView()
        
        topView.profileImageView.profileImageViewWidth = 40
        topView.profileImageView.isUserInteractionEnabled = true
        
        let rightButton = topView.rightButton
        rightButton.tintColor = .black
        let image = UIImage(systemName: "ellipsis")
        rightButton.setImage(image, for: .normal)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 24)
        rightButton.setPreferredSymbolConfiguration(symbolConfig, forImageIn: .normal)
        return topView
    }()
    
    let photoImageView = PhotoImageView(frame: .zero)
    
    let iconView = HomeCollectionViewCellIconView()
    
    let bottomView = HomeCollectionViewCellBottomView()
    
    private lazy var moveToProfileTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: nil)
        topView.profileImageView.addGestureRecognizer(tap)
        return tap
    }()
        
    weak var homeViewModel: HomeViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        topView.profileImageView.image = UIImage(systemName: "person.circle")
        photoImageView.image = UIImage(systemName: "photo")
        disposeBag = DisposeBag()
    }
    
    deinit {
        topView.profileImageView.removeGestureRecognizer(moveToProfileTap)
    }
    
    // MARK: - Custom Methods
    func updatePostData(_ element: PostLikeType) {
        topView.userNicknameLabel.text = element.post.creator.nick
        topView.subTitleLabel.text = ""
        
        if let profileImage = element.post.creator.profileImage, !profileImage.isEmpty {
            let url = URL(string: APIKeys.baseURL + "/\(profileImage)")
            let placeholderImage = UIImage(systemName: "person.circle")
            topView.profileImageView.kf.setImageWithAuthHeaders(with: url, placeholder: placeholderImage)
        }
       
        if element.post.files.count > 0 {
            let url = URL(string: APIKeys.baseURL + "/\(element.post.files[0])")
            let placeholderImage = UIImage(systemName: "photo")
            photoImageView.kf.setImageWithAuthHeaders(with: url, placeholder: placeholderImage)
        }
        
        iconView.heartStackView.label.text = "\(element.likes.count)"
        iconView.commentStackView.label.text = "\(element.comments.count)"
        bottomView.titleLabel.text = element.post.title
        bottomView.contentLabel.text = element.post.content
        
        let heartButton = iconView.heartStackView.button
        if element.likeType == .like {
            updateHeartButtonUI(heartButton, isLike: true)
        } else {
            updateHeartButtonUI(heartButton, isLike: false)
        }
    }
}

extension HomeCollectionViewCell {
    override func configureConstraints() {
        super.configureConstraints()
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
    
    override func configureUI() {
        super.configureUI()
        
        containerView.layer.cornerRadius = 16.0
        
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 4.0
        containerView.layer.masksToBounds = false
        
        topView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        topView.layer.cornerRadius = 16.0
        topView.layer.masksToBounds = true
    }
    
    func bind(_ post: PostLikeType) {
        guard let homeViewModel else { return }
        
        let heartButton = iconView.heartStackView.button
        
        topView.rightButton.rx.tap
            .bind { trigger in
                homeViewModel.otherOptionsButtonTapRelay.accept(post.post.postId)
            }
            .disposed(by: disposeBag)
        
        iconView.commentStackView.button.rx.tap
            .bind { _ in
                homeViewModel.commentButtonTapRelay.accept(post.post.postId)
            }
            .disposed(by: disposeBag)
        
        iconView.heartStackView.button.rx.tap
            .bind { _ in
                homeViewModel.heartButtonTapSubject.onNext(post)
            }
            .disposed(by: disposeBag)
        
        moveToProfileTap.rx.event
            .bind { _ in
                homeViewModel.profileImageViewTapTapSubject.onNext(post.post.creator.userId)
            }
            .disposed(by: disposeBag)
    }
}
