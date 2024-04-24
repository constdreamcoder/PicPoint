//
//  DetailDisplayCollectionViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/19/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class DetailDisplayCollectionViewCell: BaseCollectionViewCell {

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCollectionViewLayout())
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(DetailDisplayInnerCollectionViewCell.self, forCellWithReuseIdentifier: DetailDisplayInnerCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    private let coverView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = false
        DispatchQueue.main.async {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = view.bounds
            gradientLayer.colors = [
                UIColor.black.withAlphaComponent(0.0).cgColor,
                UIColor.black.withAlphaComponent(0.6).cgColor,
                UIColor.black.withAlphaComponent(0.8).cgColor
            ]
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
            gradientLayer.locations = [0.7, 0.9]
            view.layer.addSublayer(gradientLayer)
        }
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = .systemFont(ofSize: 24.0, weight: .bold)
        return label
    }()
    
    let addressLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = .systemFont(ofSize: 14.0)
        return label
    }()
    
    lazy var titleContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 8.0
        [
            titleLabel,
            addressLabel
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.maximumValue = 1
        slider.value = initialSlider
        slider.setThumbImage(UIImage(), for: .normal)
        slider.isUserInteractionEnabled = false
        slider.tintColor = .black
        return slider
    }()
    
    private let initialSlider: Float = 1
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
    
    func initializeSlider(filesCount: Int) {
        if filesCount == 0 {
            slider.maximumValue = 1
            slider.value = initialSlider
        } else {
            slider.maximumValue = Float(filesCount)
        }
    }
    
    func updateFirstSectionDatas(_ cellData: FirstSectionCellData) {
        initializeSlider(filesCount: cellData.files.count)
        bind(files: cellData.files)
        
        titleLabel.text = cellData.title
        addressLabel.text = cellData.address
    }
}

extension DetailDisplayCollectionViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        [
            collectionView,
            coverView,
            titleContainerStackView,
            slider
        ].forEach { contentView.addSubview($0) }
    
        collectionView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        coverView.snp.makeConstraints {
            $0.edges.equalTo(collectionView)
        }
        
        titleContainerStackView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(collectionView).inset(16.0)
        }
        
        slider.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom)
            $0.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(-2.0)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
    }
    
    func bind(files: [String]) {
        Observable.just(files)
            .bind(to: collectionView.rx.items(
                cellIdentifier: DetailDisplayInnerCollectionViewCell.identifier,
                cellType: DetailDisplayInnerCollectionViewCell.self)
            ) { item, element, cell in
                let url = URL(string: APIKeys.baseURL + "/\(element)")
                let placeholderImage = UIImage(systemName: "photo")
                cell.photoImageView.kf.setImageWithAuthHeaders(with: url, placeholder: placeholderImage)
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.didScroll
            .bind(with: self) { owner, _ in
                let newPage = Float(owner.collectionView.contentOffset.x / owner.collectionView.frame.width) + owner.initialSlider
                if newPage < 1 {
                    owner.slider.value = owner.initialSlider
                } else if newPage > 5 {
                    owner.slider.value = owner.slider.maximumValue
                } else {
                    owner.slider.value = newPage
                }
            }
            .disposed(by: disposeBag)
    }
}

extension DetailDisplayCollectionViewCell: UICollectionViewConfiguration {
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let itemSizeWidth = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: itemSizeWidth, height: itemSizeWidth * 1.3)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        layout.scrollDirection = .horizontal
        
        return layout
    }
}
