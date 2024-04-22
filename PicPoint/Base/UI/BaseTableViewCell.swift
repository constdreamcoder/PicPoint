//
//  BaseTableViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/17/24.
//

import UIKit
import RxSwift

class BaseTableViewCell: UITableViewCell {
    
    var disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BaseTableViewCell: UITableViewCellConfiguration {
    func configureConstraints() {
        
    }
    
    func configureUI() {
        backgroundColor = .white
        contentView.backgroundColor = .white
        
        selectionStyle = .none
    }
}
