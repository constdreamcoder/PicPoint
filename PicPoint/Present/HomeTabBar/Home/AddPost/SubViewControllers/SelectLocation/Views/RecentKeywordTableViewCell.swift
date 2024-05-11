//
//  RecentKeywordTableViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/12/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class RecentKeywordTableViewCell: BaseTableViewCell {
    
    let magnifyingglassImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.tintColor = .black
        let configuration = UIImage.SymbolConfiguration(pointSize: 18.0)
        imageView.preferredSymbolConfiguration = configuration
        return imageView
    }()
    
    let recentKeywordLabel: UILabel = {
        let label = UILabel()
        label.text = "최근 검색어"
        label.textColor = .black
        label.font = .systemFont(ofSize: 18.0)
        return label
    }()
    
    let eraseButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "xmark")
        button.setImage(image, for: .normal)
        button.tintColor = .lightGray
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 18.0)
        button.setPreferredSymbolConfiguration(imageConfiguration, forImageIn: .normal)
        return button
    }()
    
    weak var selectLocationViewModel: SelectLocationViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
}

extension RecentKeywordTableViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        [
            magnifyingglassImageView,
            recentKeywordLabel,
            eraseButton
        ].forEach { contentView.addSubview($0) }

        magnifyingglassImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
            $0.size.equalTo(18.0)
        }
        
        recentKeywordLabel.snp.makeConstraints {
            $0.centerY.equalTo(magnifyingglassImageView)
            $0.leading.equalTo(magnifyingglassImageView.snp.trailing).offset(16.0)
        }
        
        eraseButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        eraseButton.snp.makeConstraints {
            $0.centerY.equalTo(recentKeywordLabel)
            $0.leading.equalTo(recentKeywordLabel.snp.trailing).offset(16.0)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    func bind(_ recnetKeyword: RecentKeyword) {
        guard let selectLocationViewModel else { return }
        
        eraseButton.rx.tap
            .bind { _ in
                selectLocationViewModel.eraseButtonTapped.onNext(recnetKeyword)
            }
            .disposed(by: disposeBag)
    }
}
