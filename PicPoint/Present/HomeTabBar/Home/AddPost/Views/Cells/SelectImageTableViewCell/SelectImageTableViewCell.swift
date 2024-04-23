//
//  SelectImageTableViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/21/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SelectImageTableViewCell: BaseTableViewCell {
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        
        collectionView.backgroundColor = .white
        
        collectionView.register(SelectImageInnerCollectionViewCell.self, forCellWithReuseIdentifier: SelectImageInnerCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private let spacing = 8.0
    private lazy var itemSize = UIScreen.main.bounds.width - (spacing * 5)
    
    weak var addPostViewModel: AddPostViewModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}

extension SelectImageTableViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
            $0.height.equalTo(itemSize / 4 + spacing * 4)
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    func bind() {
        guard let addPostViewModel else { return }
        
        addPostViewModel.selectedImagesRelay.asDriver()
            .drive(collectionView.rx.items(cellIdentifier: SelectImageInnerCollectionViewCell.identifier, cellType: SelectImageInnerCollectionViewCell.self)) { [weak self] item, element, cell in
                guard let self else { return }
                
                if item == 0 {
                    cell.photoImageView.image = UIImage(systemName: "photo.badge.plus")
                    cell.deleteButton.isHidden = true
                } else {
                    self.getUIImageFromPHAsset(element) {
                        cell.photoImageView.image = $0
                        cell.deleteButton.isHidden = false
                    }
                }
                
                cell.deleteButton.rx.tap
                    .bind { _ in
                        self.addPostViewModel?.imageCellButtonTapSubject.onNext(item)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .bind(with: self) { owner, indexPath in
                if indexPath.item == 0 {
                    addPostViewModel.fetchPhotosTrigger.onNext(())
                }
                addPostViewModel.imageCellTapSubject.onNext(indexPath)
            }
            .disposed(by: disposeBag)
    }
}

extension SelectImageTableViewCell: UICollectionViewConfiguration {
    func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSize / 4, height: itemSize / 4)
        layout.minimumLineSpacing = spacing * 2
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing * 2, bottom: 0, right: spacing * 2)
        layout.scrollDirection = .horizontal
        
        return layout
    }
    
}
