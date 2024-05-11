//
//  FollowerViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/29/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FollowerViewController: BaseViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(FollowerTableViewCell.self, forCellReuseIdentifier: FollowerTableViewCell.identifier)
        
        return tableView
    }()
    
    let viewModel = FollowerViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
        
    }
}

extension FollowerViewController: UIViewControllerConfiguration {
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
        noContentsWarningLabel.text = "팔로워한 유저가 없습니다."
    }
    
    func bind() {
        
        let input = FollowerViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        output.followers
            .drive(tableView.rx.items(cellIdentifier: FollowerTableViewCell.identifier, cellType: FollowerTableViewCell.self)) { row, element, cell in
                
                cell.updateCellData(element)
            }
            .disposed(by: disposeBag)
        
        output.followers
            .drive(with: self) { owner, followerList in
                owner.noContentsWarningLabel.isHidden = followerList.count > 0
            }
            .disposed(by: disposeBag)
    }
}
