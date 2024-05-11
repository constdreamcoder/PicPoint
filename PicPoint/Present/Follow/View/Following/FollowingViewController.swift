//
//  FollowingViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/29/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FollowingViewController: BaseViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(FollowingTableViewCell.self, forCellReuseIdentifier: FollowingTableViewCell.identifier)
        
        return tableView
    }()
    
    let viewModel = FollowingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
        
    }
}

extension FollowingViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        
    }
    
    func configureConstraints() {
        [
            tableView,
            noContentsWarningLabel
        ].forEach { view.addSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        noContentsWarningLabel.snp.makeConstraints {
            $0.center.equalTo(tableView)
        }
    }
    
    func configureUI() {
        noContentsWarningLabel.text = "팔로잉한 유저가 없습니다."
    }
    
    func bind() {
        
        let input = FollowingViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        output.followings
            .drive(tableView.rx.items(cellIdentifier: FollowingTableViewCell.identifier, cellType: FollowingTableViewCell.self)) { [weak self] row, element, cell in
                guard let self else { return }
                cell.followingViewModel = self.viewModel
                cell.updateCellData(element)
                cell.bind(element)
            }
            .disposed(by: disposeBag)
        
        output.followings
            .drive(with: self) { owner, followingList in
                owner.noContentsWarningLabel.isHidden = followingList.count > 0
            }
            .disposed(by: disposeBag)
    }
}
