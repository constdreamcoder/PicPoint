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
import Photos

final class SelectImageViewController: BaseViewController {
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.backgroundColor = .clear
        
        collectionView.register(SelectImageCollectionViewCell.self, forCellWithReuseIdentifier: SelectImageCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    let selectedImageView: PhotoImageView = {
        let imageView = PhotoImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    let dismissButton = DismissButton()
    
    private let viewModel: SelectImageViewModel?
    
    init(
        selectImageViewModel: SelectImageViewModel
    ) {
        self.viewModel = selectImageViewModel
        
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        dismissButton.layer.cornerRadius = dismissButton.frame.width / 2
        dismissButton.clipsToBounds = true
    }
}

extension SelectImageViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationItem.title = "이미지 선택"
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: dismissButton)
                
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
        view.backgroundColor = .black
    }
    
    func bind() {
        
        guard let rightBarButtonItem = navigationItem.rightBarButtonItem else { return }
        let input = SelectImageViewModel.Input(
            dismissButtonTap: dismissButton.rx.tap, 
            rightBarButtonItemTap: rightBarButtonItem.rx.tap,
            itemTap: collectionView.rx.modelSelected(PHAsset.self)
        )
        
        guard let viewModel else { return }
        let output = viewModel.transform(input: input)
        
        output.dismissButtonTapTrigger
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.rightBarButtonItemTapTrigger
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.assets
            .drive(collectionView.rx.items(cellIdentifier: SelectImageCollectionViewCell.identifier, cellType: SelectImageCollectionViewCell.self)) { [weak self]
                item, element, cell in
                guard let self else { return }
                
                self.getUIImageFromPHAsset(element) {
                    cell.photoImageView.image = $0
                }
            }
            .disposed(by: disposeBag)
        
        output.selectedImage
            .drive(with: self) { [weak self] owner, selectedAsset in
                guard let self else { return }

                guard let selectedAsset else { return }
                self.getUIImageFromPHAsset(selectedAsset) {
                    self.selectedImageView.image = $0
                }
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
