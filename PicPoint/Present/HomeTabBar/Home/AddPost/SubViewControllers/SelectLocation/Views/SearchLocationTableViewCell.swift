//
//  SearchLocationTableViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/11/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SearchLocationTableViewCell: BaseTableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20.0)
        label.textColor = .black
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0)
        label.textColor = .lightGray
        return label
    }()

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

extension SearchLocationTableViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        [
            titleLabel,
            subTitleLabel
        ].forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4.0)
            $0.horizontalEdges.equalTo(titleLabel)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
}
