//
//  SettingTableViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/8/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SettingTableViewCell: BaseTableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 18.0)
        return label
    }()
    
    let chevronImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.forward")
        imageView.preferredSymbolConfiguration = .init(pointSize: 24.0)
        imageView.tintColor = .black
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingTableViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        [
            titleLabel,
            chevronImageView
        ].forEach { contentView.addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.bottom.leading.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
}
