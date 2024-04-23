//
//  SelectLocationTableViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/21/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SelectLocationTableViewCell: BaseTableViewCell {
    
    let innerContainerView: InnerContainerView = {
        let view = InnerContainerView()
        view.leftLabel.text = "위치선택"
        return view
    }()
    
    let rightLabel: UILabel = {
        let label = UILabel()
        label.text = "테스트"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        return label
    }()
    
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

extension SelectLocationTableViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        [
            innerContainerView,
            rightLabel
        ].forEach { contentView.addSubview($0) }
        
        innerContainerView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        rightLabel.snp.makeConstraints {
            $0.centerY.equalTo(innerContainerView.chevronButton)
            $0.trailing.equalTo(innerContainerView.chevronButton.snp.leading).offset(-4.0)
            $0.leading.equalTo(innerContainerView.leftLabel.snp.trailing).offset(4.0)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
    }
}