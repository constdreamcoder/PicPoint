//
//  MyLikeViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/26/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyLikeViewController: BaseViewController {
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false

        collectionView.register(MyLikeCollectionViewCell.self, forCellWithReuseIdentifier: MyLikeCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    let viewModel = MyLikeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.delegate?.sendMyLikeCollectionViewContentHeight(collectionView.contentSize.height == 0 ? 250 : collectionView.contentSize.height)
    }

}

extension MyLikeViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        
    }
    
    func configureConstraints() {
        [
            collectionView,
            noContentsWarningLabel
        ].forEach { view.addSubview($0) }
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        noContentsWarningLabel.snp.makeConstraints {
            $0.center.equalTo(collectionView)
        }
    }
    
    func configureUI() {
        noContentsWarningLabel.text = "게시글이 존재하지 않습니다!!"
    }
    
    func bind() {
        let input = MyLikeViewModel.Input(
            viewDidLoad: Observable.just(()),
            postTap: collectionView.rx.modelSelected(Post.self)
        )
        
        let output = viewModel.transform(input: input)
        
        output.likedPostList
            .drive(collectionView.rx.items(cellIdentifier: MyLikeCollectionViewCell.identifier, cellType: MyLikeCollectionViewCell.self)) { item, element, cell in
                cell.updateCellData(element)
            }
            .disposed(by: disposeBag)
        
        output.likedPostList
            .drive(with: self) { owner, postList in
                owner.noContentsWarningLabel.isHidden = postList.count > 0
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.willDisplayCell
            .bind(with: self) { owner, value in
                if value.at == IndexPath(item: 0, section: 0) {
                    print("MyLike CollectionView Content Size", owner.collectionView.contentSize.height)
                    owner.viewModel.delegate?.sendMyLikeCollectionViewContentHeight(owner.collectionView.contentSize.height)
                }
            }
            .disposed(by: disposeBag)
    }
}

extension MyLikeViewController: UICollectionViewConfiguration {
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(250)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
