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
        
        Observable.just(viewModel.dataList)
            .bind(to: collectionView.rx.items(cellIdentifier: HomeCollectionViewCell.identifier, cellType: HomeCollectionViewCell.self)) { item, element, cell in
                if item % 2 == 0 {
                    cell.backgroundColor = .green
                } else {
                    cell.backgroundColor = .brown
                }
            }
            .disposed(by: disposeBag)
            
        guard let rightBarButtonItem = navigationItem.rightBarButtonItem else { return }
        let input = HomeViewModel.Input(
            rightBarButtonItemTapped: rightBarButtonItem.rx.tap
        )
        
        let output = viewModel.transform(input: input)
    }
}

extension HomeViewController: UICollectionViewConfiguration {
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        guard let navigationController else { return UICollectionViewLayout() }
        let navigationBarHeight = navigationController.navigationBar.frame.height
        let topSafeareInset = getSafeAreaInset().top
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width,
                                 height: view.frame.size.height - (topSafeareInset + navigationBarHeight + tabBarHeight))
        layout.sectionInset = .zero
        layout.minimumLineSpacing = .zero
        layout.minimumInteritemSpacing = .zero
                
        return layout
    }
    
    
}
