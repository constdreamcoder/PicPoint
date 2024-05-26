//
//  MyChatRoomsTableViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/18/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class MyChatRoomsTableViewCell: BaseTableViewCell {
    
    let userImageView: ProfileImageView = {
        let imageView = ProfileImageView(frame: .zero)
        imageView.profileImageViewWidth = 44.0
        return imageView
    }()
    
    let userNicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "개발개발"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 16.0)
        return label
    }()
    
    let lastContentLabel: UILabel = {
        let label = UILabel()
        label.text = "대화 내용 없음"
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 14.0)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2.0
        [
            userNicknameLabel,
            lastContentLabel
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    let datelabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12.0)
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
        
        userImageView.image = UIImage(systemName: "person.circle")
        lastContentLabel.text = "대화 내용 없음"
        datelabel.text = nil
    }
}

extension MyChatRoomsTableViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        
        [
            userImageView,
            labelStackView,
            datelabel
        ].forEach { contentView.addSubview($0) }
        
        userImageView.snp.makeConstraints {
            $0.top.leading.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
            $0.size.equalTo(userImageView.profileImageViewWidth)
        }
        
        labelStackView.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(12.0)
            $0.centerY.equalTo(userImageView)
            $0.trailing.lessThanOrEqualTo(datelabel.snp.leading).offset(-12.0)
        }
        
        datelabel.snp.makeConstraints {
            $0.centerY.equalTo(userImageView)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
}
