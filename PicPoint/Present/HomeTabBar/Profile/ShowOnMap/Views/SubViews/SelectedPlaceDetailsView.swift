//
//  SelectedPlaceDetailsView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/6/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class SelectedPlaceDetailsView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "알람브라"
        label.textColor = .black
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = "서울시 연수구 성수동"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()
    
    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4.0
        stackView.distribution = .equalSpacing
        [
            titleLabel,
            addressLabel
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        
        collectionView.register(SelectedPlaceDetailsCollectionViewCell.self, forCellWithReuseIdentifier: SelectedPlaceDetailsCollectionViewCell.identifier)
        
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
    let viewModel = SelectedPlaceDetailsViewModel()
    
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
        configureUI()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configureConstraints() {
        [
            labelStackView,
            closeButton,
            collectionView
        ].forEach { addSubview($0) }
        
        labelStackView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(16.0)
        }
        
        closeButton.snp.makeConstraints {
            $0.centerY.equalTo(labelStackView)
            $0.trailing.equalToSuperview().inset(16.0)
        }
        
        let height = (UIScreen.main.bounds.width - (16.0 * 4) - (4.0 * 2)) / 3
        collectionView.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(8.0)
            $0.leading.equalTo(labelStackView)
            $0.trailing.equalTo(closeButton)
            $0.bottom.equalToSuperview().inset(16.0)
            $0.height.equalTo(height)
        }
    }
    
    private func configureUI() {
        backgroundColor = .white
        layer.cornerRadius = 16.0
    }
        
    private func bind() {
        
        let input = SelectedPlaceDetailsViewModel.Input(
            closeButtonTapped: closeButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.files
            .drive(collectionView.rx.items(cellIdentifier: SelectedPlaceDetailsCollectionViewCell.identifier, cellType: SelectedPlaceDetailsCollectionViewCell.self)) { item, element, cell in
                
                let url = URL(string: APIKeys.baseURL + "/\(element)")
                let placeholderImage = UIImage(systemName: "photo")
                cell.photoImageView.kf.setImageWithAuthHeaders(with: url, placeholder: placeholderImage)
            }
            .disposed(by: disposeBag)
        
        output.closeTrigger
            .drive(with: self) { owner, _ in
                owner.isHidden = true
            }
            .disposed(by: disposeBag)
    }
}

extension SelectedPlaceDetailsView: UICollectionViewConfiguration {
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        
        let spacing: CGFloat = 4.0
        
        let itemSize = (UIScreen.main.bounds.width - (16 * 4) - (spacing * 2)) / 3
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        layout.scrollDirection = .horizontal
        
        return layout
    }
}
