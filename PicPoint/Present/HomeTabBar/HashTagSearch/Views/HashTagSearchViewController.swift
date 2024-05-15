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
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: pinterestLayout)
        collectionView.backgroundColor = .white
        
        collectionView.register(HashTagSearchCollectionViewCell.self, forCellWithReuseIdentifier: HashTagSearchCollectionViewCell.identifier)
        
        
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        
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
        navigationItem.titleView = searchBar
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
        
        guard let refreshControl = collectionView.refreshControl else { return }
        
        let input = HashTagSearchViewModel.Input(
            viewDidLoad: viewDidLoad,
            searText: searchBar.rx.text.orEmpty,
            searchButtonClicked: searchBar.rx.searchButtonClicked, 
            refreshControlValueChanged: refreshControl.rx.controlEvent(.valueChanged)
        )
        
        let output = viewModel.transform(input: input)
        
        output.postList
            .drive(collectionView.rx.items(cellIdentifier: HashTagSearchCollectionViewCell.identifier, cellType: HashTagSearchCollectionViewCell.self)) { item, element, cell in
                cell.thumnailImageView.image = element.image
                
            }
            .disposed(by: disposeBag)
        
        output.endRefreshControlTrigger
            .drive { _ in
                refreshControl.endRefreshing()
            }
            .disposed(by: disposeBag)
    }
}

extension HashTagSearchViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return viewModel.postListRelay.value[indexPath.item].image.size.height
    }
}
