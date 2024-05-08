//
//  PaymentListTableViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/8/24.
//

import UIKit
import SnapKit

final class PaymentListTableViewCell: BaseTableViewCell {
    
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20.0)
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 20.0)
        return label
    }()
    
    let paidAtLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = .boldSystemFont(ofSize: 16.0)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PaymentListTableViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        
        [
            productNameLabel,
            priceLabel,
            paidAtLabel
        ].forEach { contentView.addSubview($0) }
        
        productNameLabel.snp.makeConstraints {
            $0.top.leading.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
            $0.trailing.lessThanOrEqualTo(priceLabel).offset(-4.0)
        }
        
        priceLabel.snp.makeConstraints {
            $0.centerY.equalTo(productNameLabel)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
        
        paidAtLabel.snp.makeConstraints {
            $0.top.equalTo(productNameLabel.snp.bottom).offset(8.0)
            $0.leading.equalTo(productNameLabel)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
        
    }
    
    override func configureUI() {
        super.configureUI()
    }
}
