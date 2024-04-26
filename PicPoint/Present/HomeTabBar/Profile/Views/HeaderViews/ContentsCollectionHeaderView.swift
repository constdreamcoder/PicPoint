//
//  ContentsCollectionReusableVie.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/25/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ContentsCollectionHeaderView: UICollectionReusableView {
    
    var disposeBag = DisposeBag()
    
    let menuSegmentControl = UnderlineSegmentedControl(items: ["포스팅", "좋아요"])
        
    weak var profileViewModel: ProfileViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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

extension ContentsCollectionHeaderView: UIViewConfiguration {
    func configureConstraints() {
        addSubview(menuSegmentControl)
        
        menuSegmentControl.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24.0)
            $0.leading.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(UIScreen.main.bounds.width * 0.4)
        }
    }
    
    func configureUI() {
        backgroundColor = .white
        
        menuSegmentControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.gray,
            .font: UIFont.systemFont(ofSize: 20, weight: .semibold)
        ], 
        for: .normal
        )
        menuSegmentControl.setTitleTextAttributes(
          [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            .font: UIFont.systemFont(ofSize: 20, weight: .semibold)
          ],
          for: .selected
        )
        menuSegmentControl.selectedSegmentIndex = 0
    }
    
    func bind() {
        guard let profileViewModel else { return }
        
        menuSegmentControl.rx.selectedSegmentIndex
            .bind {
                profileViewModel.segmentControlSelectedIndexRelay.accept($0)
            }
            .disposed(by: disposeBag)
    }
}
