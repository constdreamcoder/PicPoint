//
//  HashTagSearchViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/15/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class HashTagSearchViewController: BaseViewController {
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: pinterestLayout)
        collectionView.backgroundColor = .white
        
        collectionView.register(HashTagSearchCollectionViewCell.self, forCellWithReuseIdentifier: HashTagSearchCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    lazy var pinterestLayout: PinterestLayout = {
        let layout = PinterestLayout()
        layout.delegate = self
        return layout
    }()
    
    private let viewModel = HashTagSearchViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
    }
}

extension HashTagSearchViewController: UIViewControllerConfiguration {
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
        
        let viewDidLoad = Observable.just(())
        
        let input = HashTagSearchViewModel.Input(viewDidLoad: viewDidLoad)
        
        let output = viewModel.transform(input: input)
        
        output.postList
            .drive(collectionView.rx.items(cellIdentifier: HashTagSearchCollectionViewCell.identifier, cellType: HashTagSearchCollectionViewCell.self)) { item, element, cell in
                cell.thumnailImageView.image = element.image
                
            }
            .disposed(by: disposeBag)
    }
}

extension HashTagSearchViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return viewModel.postListRelay.value[indexPath.item].image.size.height
    }
}
