//
//  SelectImageViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/22/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SelectImageViewController: BaseViewController {
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.backgroundColor = .white
        
        collectionView.register(SelectImageCollectionViewCell.self, forCellWithReuseIdentifier: SelectImageCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    let selectedImageView: PhotoImageView = {
        let imageView = PhotoImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let viewModel = SelectImageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
    }
}

extension SelectImageViewController {
    @objc func leftBarButtonItemTapped(_ barButtonItem: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

extension SelectImageViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationItem.title = "이미지 선택"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(leftBarButtonItemTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: nil)
    }
    
    func configureConstraints() {
        [
            selectedImageView,
            collectionView
        ].forEach { view.addSubview($0) }
       
        
        selectedImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(UIScreen.main.bounds.height * 0.55)
            $0.bottom.equalTo(collectionView.snp.top)
        }
        
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        
    }
    
    func bind() {
        
        guard let rightBarButtonItem = navigationItem.rightBarButtonItem else { return }
        let input = SelectImageViewModel.Input(
            rightBarButtonItemTap: rightBarButtonItem.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.rightBarButtonItemTapTrigger
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        Observable.just([1,2,3,4,5,6,7,8,9,90,34,52,345,2])
            .bind(to: collectionView.rx.items(cellIdentifier: SelectImageCollectionViewCell.identifier, cellType: SelectImageCollectionViewCell.self)) {
                item, element, cell in
                
            }
            .disposed(by: disposeBag)
        
    }
}

extension SelectImageViewController: UICollectionViewConfiguration {
    func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.25),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.25)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
                
        let section = NSCollectionLayoutSection(group: group)
        
        section.interGroupSpacing = 0
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
