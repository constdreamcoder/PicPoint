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
        collectionView.register(DetailRelatedContentsCollectionViewCell.self, forCellWithReuseIdentifier: DetailRelatedContentsCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private lazy var dataSource = RxCollectionViewSectionedReloadDataSource<SectionModelWrapper> { dataSource, collectionView, indexPath, item in
        
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
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailRelatedContentsCollectionViewCell.identifier, for: indexPath) as? DetailRelatedContentsCollectionViewCell else { return UICollectionViewCell() }
            
            return cell
        }
        return UICollectionViewCell()
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
        
    }
    
    func configureConstraints() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        
    }
    
    func bind() {
        let input = DetailViewModel.Input()
        
        guard let viewModel = viewModel else { return }
        let output = viewModel.transform(input: input)
        
        output.sections
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension DetailViewController: UICollectionViewConfiguration {
    func createCollectionViewLayout() -> UICollectionViewLayout {
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
                return section
            }
            return nil
        }
    }
}
