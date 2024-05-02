//
//  ContentsCollectionViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/25/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ContentsCollectionViewCell: BaseCollectionViewCell {
    
    var contentsPageVC = ContentsPageViewController()
    
    weak var profileViewModel: ProfileViewModel?
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
}

extension ContentsCollectionViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        contentView.addSubview(contentsPageVC.view)
        
        contentsPageVC.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func configureUI() {
        super.configureUI()
    }
    
    func bind() {
        guard let profileViewModel else { return }
        profileViewModel.segmentControlSelectedIndexRelay.asDriver()
            .drive(with: self) { owner, selectedIndex in
                owner.contentsPageVC.currentPage = selectedIndex
            }
            .disposed(by: disposeBag)
                
        contentsPageVC.myPostVC.viewModel.delegate = profileViewModel
        contentsPageVC.MyLikeVC.viewModel.delegate = profileViewModel
        
        profileViewModel.delegate = contentsPageVC.myPostVC.viewModel
    }
}
