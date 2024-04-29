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
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        
    }
    
    func bind() {
        Observable.just([1,2,3,4,45])
            .bind(to: tableView.rx.items(cellIdentifier: FollowingTableViewCell.identifier, cellType: FollowingTableViewCell.self)) { row, element, cell in
                
            }
            .disposed(by: disposeBag)
    }
}
