//
//  DetailIntroductionCollectionViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/19/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class DetailIntroductionCollectionViewCell: BaseCollectionViewCell {
    
    let topView: HomeCollectionViewCellTopView = {
        let topView = HomeCollectionViewCellTopView()
        
        topView.profileImageView.profileImageViewWidth = 40

        let rightButton = topView.rightButton
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = .black
        buttonConfiguration.baseForegroundColor = .white
        buttonConfiguration.buttonSize = .small
        buttonConfiguration.title = "팔로우"
        rightButton.configuration = buttonConfiguration
        return topView
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16.0)
        label.numberOfLines = 0
        return label
    }()
    
    weak var detailViewModel: DetailViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateSecondSectionDatas(_ cellData: SecondSectionCellData) {
        if let profileImage = cellData.creator.profileImage, !profileImage.isEmpty {
            let url = URL(string: APIKeys.baseURL + "/\(profileImage)")
            let placeholderImage = UIImage(systemName: "person.circle")
            topView.profileImageView.kf.setImageWithAuthHeaders(with: url, placeholder: placeholderImage)
        }
        topView.userNicknameLabel.text = cellData.creator.nick
        topView.subTitleLabel.text = cellData.visitDate
        contentLabel.text = cellData.content
    }
}

extension DetailIntroductionCollectionViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        
        [
            topView,
            contentLabel
        ].forEach { contentView.addSubview($0) }
        
        topView.snp.makeConstraints {
            $0.height.equalTo(56.0)
            $0.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom).offset(16.0)
            $0.horizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    override func configureUI() {
        super.configureUI()
                
        topView.rightButton.rx.tap
            .subscribe(with: self, onNext: { owner, trigger in
                owner.detailViewModel?.tap.accept(trigger)
            })
            .disposed(by: disposeBag)
    }
}
