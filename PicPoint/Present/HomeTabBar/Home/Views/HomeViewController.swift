//
//  HomeViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class HomeViewController: BaseViewController {
    
    let leftBarButtonItemLabel: UILabel = {
        let label = UILabel()
        label.text = "서울시 동작구"
        label.textColor = .black
        label.font = .systemFont(ofSize: 20.0, weight: .bold)
        return label
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
    }
    
    // MARK: - Custom Methods
    private func getSafeAreaInset() -> UIEdgeInsets {
        let connectedScene = UIApplication.shared.connectedScenes.first
        
        let windowScene = connectedScene as? UIWindowScene
        
        let window = windowScene?.windows.first
        
        let safeAreaInset = window?.safeAreaInsets ?? .zero
        print("safeAreaInset", safeAreaInset)
        print("statusBarFrame", window?.windowScene?.statusBarManager?.statusBarFrame)
        return safeAreaInset
    }
}

extension HomeViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBarButtonItemLabel)
        
        let rightBarButtonItemImage = UIImage(systemName: "magnifyingglass")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarButtonItemImage, style: .plain, target: self, action: nil)
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
        guard let rightBarButtonItem = navigationItem.rightBarButtonItem else { return }
        
        let input = HomeViewModel.Input(
            viewDidLoadTrigger: Observable<Void>.just(()),
            rightBarButtonItemTapped: rightBarButtonItem.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.postList
            .drive(collectionView.rx.items(cellIdentifier: HomeCollectionViewCell.identifier, cellType: HomeCollectionViewCell.self)) { item, element, cell in
                
                cell.updatePostData(element)
            }
            .disposed(by: disposeBag)
        
        Observable.zip(
            collectionView.rx.itemSelected,
            collectionView.rx.modelSelected(Post.self)
        )
        .bind(with: self) { owner, value in
            let detailVC = DetailViewController(detailViewModel: DetailViewModel(post: value.1))
            owner.navigationController?.pushViewController(detailVC, animated: true)
        }
        .disposed(by: disposeBag)
        
    }
}

extension HomeViewController: UICollectionViewConfiguration {
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
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
