//
//  MyPostViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/26/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyPostViewController: BaseViewController {
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        
        collectionView.register(MyPostCollectionViewCell.self, forCellWithReuseIdentifier: MyPostCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    let viewModel = MyPostViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.delegate?.sendMyPostCollectionViewContentHeight(collectionView.contentSize.height)
    }
}

extension MyPostViewController: UIViewControllerConfiguration {
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
        let input = MyPostViewModel.Input(
            viewDidLoad: Observable.just(()),
            postTap: collectionView.rx.modelSelected(Post.self)
        )
        
        let output = viewModel.transform(input: input)
        
        output.myPostsList
            .drive(collectionView.rx.items(cellIdentifier: MyPostCollectionViewCell.identifier, cellType: MyPostCollectionViewCell.self)) { item, element, cell in
                cell.updateCellData(element)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.willDisplayCell
            .bind(with: self) { owner, value in
                if value.at == IndexPath(item: 0, section: 0) {
                    print("MyPost CollectionView Content Size", owner.collectionView.contentSize.height)
                    owner.viewModel.delegate?.sendMyPostCollectionViewContentHeight(owner.collectionView.contentSize.height)
                }
            }
            .disposed(by: disposeBag)
    }
}

extension MyPostViewController: UICollectionViewConfiguration {
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(230)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
