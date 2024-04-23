//
//  VisitDateTableViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/21/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class VisitDateTableViewCell: BaseTableViewCell {
    
    let innerContainerView: InnerContainerView = {
        let view = InnerContainerView()
        view.leftLabel.text = "방문일"
        return view
    }()
    
    let rightLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        return label
    }()
    
    weak var addPostViewModel: AddPostViewModel?
    
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

extension VisitDateTableViewCell {
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
    
    func bind() {
        guard let addPostViewModel else { return }
        
        // TODO: - 새로운 날짜 선택 후에도 방문일 버튼을 다시 탭하면 오늘 날짜로 다시 보이는 오류 수정 필요
        addPostViewModel.visitDateRelay.asDriver()
            .drive(with: self) { owner, visitDate in
                owner.rightLabel.text = visitDate.convertToDateString
            }
            .disposed(by: disposeBag)
    }
}
