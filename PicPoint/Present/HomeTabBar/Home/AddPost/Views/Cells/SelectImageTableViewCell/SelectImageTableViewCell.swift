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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureConstraints()
        configureUI()
        bind()
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
        Observable.just([1, 2, 3, 4, 5, 6])
            .bind(to: collectionView.rx.items(cellIdentifier: SelectImageInnerCollectionViewCell.identifier, cellType: SelectImageInnerCollectionViewCell.self)) { item, element, cell in
                
            }
            .disposed(by: disposeBag)
    }
}

extension SelectImageTableViewCell: UICollectionViewConfiguration {
    func createCollectionViewLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemSize / 4, height: itemSize / 4)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 16, left: spacing * 2, bottom: 16, right: spacing * 2)
        layout.scrollDirection = .horizontal
        
        return layout
    }
    
}
