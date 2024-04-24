//
//  DetailViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/17/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher
import Differentiator

final class DetailViewController: BaseViewController {
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.backgroundColor = .white
        
        collectionView.register(DetailDisplayCollectionViewCell.self, forCellWithReuseIdentifier: DetailDisplayCollectionViewCell.identifier)
        collectionView.register(DetailIntroductionCollectionViewCell.self, forCellWithReuseIdentifier: DetailIntroductionCollectionViewCell.identifier)
        
        collectionView.register(
            DetailLocationCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DetailLocationCollectionReusableView.identifier
        )
        collectionView.register(DetailLocationCollectionViewCell.self, forCellWithReuseIdentifier: DetailLocationCollectionViewCell.identifier)
        
        collectionView.register(
            DetailRelatedContentCollectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DetailRelatedContentCollectionHeaderView.identifier
        )
        collectionView.register(DetailRelatedContentsCollectionViewCell.self, forCellWithReuseIdentifier: DetailRelatedContentsCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private let bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 2.0
        view.layer.shadowOpacity = 0.1
        return view
    }()
    
    private let iconView = HomeCollectionViewCellIconView()
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<SectionModelWrapper> { [weak self] dataSource, collectionView, indexPath, item in
        guard let self else { return UICollectionViewCell() }
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailDisplayCollectionViewCell.identifier, for: indexPath) as? DetailDisplayCollectionViewCell else { return UICollectionViewCell() }
            
            if let cellData = item as? FirstSectionCellData {
                cell.updateFirstSectionDatas(cellData)
            }
            return cell
        } else if indexPath.section == 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailIntroductionCollectionViewCell.identifier, for: indexPath) as? DetailIntroductionCollectionViewCell else { return UICollectionViewCell() }
            if let cellData = item as? SecondSectionCellData {
                cell.updateSecondSectionDatas(cellData)
            }
            return cell
            
        } else if indexPath.section == 2 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailLocationCollectionViewCell.identifier, for: indexPath) as? DetailLocationCollectionViewCell else { return UICollectionViewCell() }
            if let cellData = item as? ThirdSectionCellData {
                cell.updateThirdSectionDatas(cellData)
                cell.detailViewModel = viewModel
                cell.bind(cellData)
            }
            return cell
        } else if indexPath.section == 3 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailRelatedContentsCollectionViewCell.identifier, for: indexPath) as? DetailRelatedContentsCollectionViewCell else { return UICollectionViewCell() }
            
            return cell
        }
        return UICollectionViewCell()
    } configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            if indexPath.section == 2 {
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: DetailLocationCollectionReusableView.identifier,
                    for: indexPath) as? DetailLocationCollectionReusableView else { return UICollectionReusableView() }
                
                return header
            } else if indexPath.section == 3 {
                guard let header = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: DetailRelatedContentCollectionHeaderView.identifier,
                    for: indexPath) as? DetailRelatedContentCollectionHeaderView else { return UICollectionReusableView() }
                
                return header
            } else {
                return UICollectionReusableView()
            }
        default:
            return UICollectionReusableView()
        }
    }
    
    private let viewModel: DetailViewModel?
    
    init(detailViewModel: DetailViewModel) {
        self.viewModel = detailViewModel
        
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
}

extension DetailViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        tabBarController?.tabBar.isHidden = true
        navigationItem.title = "상세화면"
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
    }
    
    func configureConstraints() {
        bottomView.addSubview(iconView)
        
        iconView.snp.makeConstraints {
            $0.edges.equalTo(bottomView)
        }
        
        [
            collectionView,
            bottomView
        ].forEach { view.addSubview($0) }
        
        collectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(bottomView.snp.top)
        }
        
        bottomView.snp.makeConstraints {
            $0.height.equalTo(50.0)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        
    }
    
    func bind() {
    
        let input = DetailViewModel.Input(
            commentButtonTap: iconView.commentStackView.button.rx.tap
        )
        
        guard let viewModel = viewModel else { return }
        let output = viewModel.transform(input: input)
        
        output.sections
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.post
            .drive(with: self) { owner, post in
                guard let post else { return }
                
                owner.iconView.heartStackView.label.text = "\(post.likes.count)"
                owner.iconView.commentStackView.label.text = "\(post.comments.count)"
            }
            .disposed(by: disposeBag)
        
        output.postId
            .drive(with: self) { owner, postId in
                let commentVC = CommentViewController(commentViewModel: CommentViewModel(postId: postId))
                let commenetNav = UINavigationController(rootViewController: commentVC)
                owner.present(commenetNav, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.mapViewTapTrigger
            .drive(with: self) { owner, coordinates in
                print("coordinates",coordinates)
                let mapPreviewVC = MapPreviewViewController()
                mapPreviewVC.coordinates = coordinates
                owner.navigationController?.pushViewController(mapPreviewVC, animated: true)
            }
            .disposed(by: disposeBag)
        
    }
}

extension DetailViewController: UICollectionViewConfiguration {
    func createCollectionViewLayout() -> UICollectionViewLayout {
        // TODO: - 열거형으로 정리하기
        return UICollectionViewCompositionalLayout { sectionNumber, layoutEnvironment -> NSCollectionLayoutSection? in
            if sectionNumber == 0 {
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)
                    )
                )
                item.contentInsets = .zero
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalWidth(1.3)
                    ),
                    subitems: [item]
                )
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .paging
                return section
            } else if sectionNumber == 1 {
                var config = UICollectionLayoutListConfiguration(appearance: .plain)
                config.showsSeparators = false
                
                let section = NSCollectionLayoutSection.list(
                    using: config,
                    layoutEnvironment: layoutEnvironment
                )
                
                return section
            } else if sectionNumber == 2 {
                var config = UICollectionLayoutListConfiguration(appearance: .plain)
                config.showsSeparators = false
                
                let section = NSCollectionLayoutSection.list(
                    using: config,
                    layoutEnvironment: layoutEnvironment
                )
                
                let headerFooterSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(56.0)
                )
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerFooterSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
                section.boundarySupplementaryItems = [header]
                
                return section
            } else if sectionNumber == 3 {
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(0.5),
                        heightDimension: .fractionalHeight(1.0)
                    )
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(380)
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
                section.boundarySupplementaryItems = [header]
                
                return section
            }
            return nil
        }
    }
}
