//
//  DirectMessageTableViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/16/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DirectMessageTableViewCell: BaseTableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .brown
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DirectMessageTableViewCell {
    override func configureConstraints() {
        super.configureConstraints()
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    func bind() {
        
    }
}
