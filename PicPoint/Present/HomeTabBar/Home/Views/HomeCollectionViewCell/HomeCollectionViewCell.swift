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
        
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.register(ImageViewCollectionViewCell.self, forCellWithReuseIdentifier: ImageViewCollectionViewCell.identifier)
        return collectionView
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.backgroundColor = .clear
        pageControl.allowsContinuousInteraction = true
        return pageControl
    }()
    
    let iconView = HomeCollectionViewCellIconView()
    
    let bottomView = HomeCollectionViewCellBottomView()
    
    private lazy var coverView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        DispatchQueue.main.async {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = view.bounds
            gradientLayer.colors = [
                UIColor.black.withAlphaComponent(0.0).cgColor,
                UIColor.black.withAlphaComponent(0.4).cgColor,
                UIColor.black.withAlphaComponent(0.6).cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.locations = [0.7, 0.9]
            view.layer.addSublayer(gradientLayer)
        }
        return view
    }()
    
    private lazy var moveToDetailTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: nil)
        collectionView.addGestureRecognizer(tap)
        return tap
    }()
    
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
        disposeBag = DisposeBag()
    }
    
    deinit {
        collectionView.removeGestureRecognizer(moveToDetailTap)
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
        
        pageControl.numberOfPages = element.post.files.count
        
        topView.subTitleLabel.text = element.post.content1?.components(separatedBy: "/")[3]
        
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
        
        if UserDefaults.standard.userId == element.post.creator.userId {
            topView.rightButton.isHidden = false
        } else {
            topView.rightButton.isHidden = true
        }
    }
}

extension HomeCollectionViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        [
            topView,
            collectionView,
            coverView,
            bottomView,
            pageControl,
            iconView
        ].forEach { containerView.addSubview($0) }
        
        topView.snp.makeConstraints {
            $0.height.equalTo(56.0)
            $0.top.horizontalEdges.equalTo(containerView)
        }
    
        collectionView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.width.equalTo(containerView)
            $0.bottom.equalTo(iconView.snp.top)
        }
        
        bottomView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(containerView)
            $0.bottom.equalTo(pageControl.snp.top)
        }
        
        pageControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24.0)
            $0.bottom.equalTo(iconView.snp.top)
        }
        
        iconView.snp.makeConstraints {
            $0.height.equalTo(52.0)
            $0.horizontalEdges.equalTo(containerView)
            $0.bottom.equalTo(containerView)
        }
        
        
        coverView.snp.makeConstraints {
            $0.edges.equalTo(collectionView)
        }
        
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints {
            $0.top.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(24.0)
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
                homeViewModel.profileImageViewTapSubject.onNext(post.post.creator.userId)
            }
            .disposed(by: disposeBag)
        
        moveToDetailTap.rx.event
            .bind { _ in
                homeViewModel.postTapSubject.onNext(post)
            }
            .disposed(by: disposeBag)
        
        Observable.just(post.post.files)
            .bind(to: collectionView.rx.items(cellIdentifier: ImageViewCollectionViewCell.identifier, cellType: ImageViewCollectionViewCell.self)) { item, element, cell in
                cell.updatedCellData(element)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.didScroll
            .bind { _ in
                print("d")
            }
            .disposed(by: disposeBag)
    }
}

extension HomeCollectionViewCell: UICollectionViewConfiguration {
    func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .groupPaging
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
