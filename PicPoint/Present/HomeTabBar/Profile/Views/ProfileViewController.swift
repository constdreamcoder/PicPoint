//
//  ProfileViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/15/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

final class ProfileViewController: BaseViewController {
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.backgroundColor = .white
        
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
        
        collectionView.register(
            ContentsCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ContentsCollectionHeaderView.identifier
        )
        collectionView.register(ContentsCollectionViewCell.self, forCellWithReuseIdentifier: ContentsCollectionViewCell.identifier)
        
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        
        return collectionView
    }()
    
    let goToMapButton: UIButton = {
        let button = UIButton()
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = .black
        buttonConfiguration.baseForegroundColor = .white
        buttonConfiguration.title = "지도로 보기"
        buttonConfiguration.buttonSize = .large
        buttonConfiguration.background.cornerRadius = 32.0
        button.configuration = buttonConfiguration
        return button
    }()
        
    private lazy var dataSoure = RxCollectionViewSectionedReloadDataSource<SectionModelWrapper> { [weak self] dataSource, collectionView, indexPath, item in
        guard let self else { return UICollectionViewCell()}
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as? ProfileCollectionViewCell else { return UICollectionViewCell() }
            
            cell.profileViewModel = viewModel
            cell.bind()
            
            return cell
        } else if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentsCollectionViewCell.identifier, for: indexPath) as? ContentsCollectionViewCell else { return UICollectionViewCell() }
            
            cell.profileViewModel = viewModel
            cell.bind()
        
            return cell
        }
        return UICollectionViewCell()
    } configureSupplementaryView: { [weak self] dataSource, collectionView, kind, indexPath in
        guard let self else { return UICollectionReusableView() }
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if indexPath.section == 1 {
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: ContentsCollectionHeaderView.identifier,
                    for: indexPath) as? ContentsCollectionHeaderView else { return UICollectionReusableView() }
                
                header.profileViewModel = viewModel
                header.bind()
                return header
            }
            return UICollectionReusableView()
        default:
            return UICollectionReusableView()
        }
    }
        
    private var currentCellHeight: CGFloat = 250

    private let viewModel: ProfileViewModel
    
    init(profileViewModel: ProfileViewModel) {
        self.viewModel = profileViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
    }

    func updateCellHeight(height: CGFloat) {
        currentCellHeight = height
        collectionView.collectionViewLayout.invalidateLayout()  // 레이아웃 갱신
    }
}

extension ProfileViewController {
    @objc func rightBarButtonTapped(_ barButtonItem: UIBarButtonItem) {
        print("설정으로 이동")
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
}

extension ProfileViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        
        let rightBarButtonImage = UIImage(systemName: "gearshape")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarButtonImage, style: .plain, target: self, action: #selector(rightBarButtonTapped))
    }
    
    func configureConstraints() {
        [
            collectionView,
            goToMapButton
        ].forEach { view.addSubview($0) }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        goToMapButton.snp.makeConstraints {
            $0.centerX.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    func configureUI() {
        
    }
    
    func bind() {
        
        guard let refreshControl = collectionView.refreshControl else { return }
        
        let input = ProfileViewModel.Input(
            viewWillAppear: rx.viewWillAppear, 
            refreshControlValueChanged: refreshControl.rx.controlEvent(.valueChanged),
            goToMapButtonTapped: goToMapButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.sections
            .drive(collectionView.rx.items(dataSource: dataSoure))
            .disposed(by: disposeBag)
        
        output.updateContentSize
            .drive(with: self) { owner, newContentHeight in
                owner.updateCellHeight(height: newContentHeight)
            }
            .disposed(by: disposeBag)
        
        output.editProfileButtonTapTrigger
            .drive(with: self) { owner, myProfile in
                guard let myProfile else { return }
                let editViewModel = EditViewModel(myProfile: myProfile)
                editViewModel.delegate = owner.viewModel
                let editProfileVC = EditProfileViewController(editViewModel: editViewModel)
                let editProfileNav = UINavigationController(rootViewController: editProfileVC)
                editProfileNav.modalPresentationStyle = .fullScreen
                owner.present(editProfileNav, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.moveToFollowTapTrigger
            .drive(with: self) { owner, myProfile in
                let followViewModel = FollowViewModel(myProfile: myProfile)
                let followVC = FollowViewController(followViewModel: followViewModel)
                owner.navigationController?.pushViewController(followVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.myProfile
            .drive(with: self) { owner, myProfile in
                guard let myProfile else { return }
                owner.navigationItem.backButtonTitle = myProfile.nick
                
                if UserDefaultsManager.userId == myProfile.userId  {
                    owner.navigationItem.rightBarButtonItem?.isHidden = false
                } else {
                    owner.navigationItem.rightBarButtonItem?.isHidden = true
                }
            }
            .disposed(by: disposeBag)
        
        output.moveToDetailVCTrigger
            .drive(with: self) { owner, post in
                if let post {
                    let detailVM = DetailViewModel(post: post)
                    let detailVC = DetailViewController(detailViewModel: detailVM)
                    owner.navigationController?.pushViewController(detailVC, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        output.endRefreshTrigger
            .drive(with: self) { owner, _ in
                refreshControl.endRefreshing()
            }
            .disposed(by: disposeBag)
        
        output.goToMapButtonTrigger
            .drive(with: self) { owner, value in
                let showOnMapVM = ShowOnMapViewModel(value.0, value.1)
                let showOnMapVC = ShowOnMapViewController(showOnMapViewModel: showOnMapVM)
                owner.navigationController?.pushViewController(showOnMapVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.goToDirectMessageVCTrigger
            .drive(with: self) { owner, room in
                guard let room else { return }
                let viewModel = DirectMessageViewModel(room)
                let directMessageVC = DirectMessageViewController(directMessageViewModel: viewModel)
                owner.navigationController?.pushViewController(directMessageVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.isHiddenTabBarTrigger
            .drive(with: self) { owner, isHidden in
                owner.tabBarController?.tabBar.isHidden = isHidden
            }
            .disposed(by: disposeBag)
    }
}

extension ProfileViewController: UICollectionViewConfiguration {
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionNumber, layoutEnvironment -> NSCollectionLayoutSection? in
            guard let self else { return nil }
            
          if sectionNumber == 0 {
                var config = UICollectionLayoutListConfiguration(appearance: .plain)
                config.showsSeparators = false
                
                let section = NSCollectionLayoutSection.list(
                    using: config,
                    layoutEnvironment: layoutEnvironment
                )
                
                return section
            } else if sectionNumber == 1 {
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(currentCellHeight)
                    )
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .absolute(currentCellHeight)
                    ),
                    subitems: [item]
                )
                group.interItemSpacing = .fixed(2)
                
                let section = NSCollectionLayoutSection(group: group)
                
                let headerFooterSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(56.0)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerFooterSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                
                header.pinToVisibleBounds = true
                section.boundarySupplementaryItems = [header]
                
                return section
            }
            return nil
        }
        return layout
    }
}
