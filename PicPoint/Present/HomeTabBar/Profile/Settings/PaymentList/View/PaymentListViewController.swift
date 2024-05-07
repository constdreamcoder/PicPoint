//
//  PaymentListViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/8/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PaymentListViewController: BaseViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(PaymentListTableViewCell.self, forCellReuseIdentifier: PaymentListTableViewCell.identifier)
        
        return tableView
    }()
    
    private let viewModel: PaymentListViewModel
    
    init(paymentListViewModel: PaymentListViewModel) {
        self.viewModel = paymentListViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
    }
}

extension PaymentListViewController: UIViewControllerConfiguration {
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
        
        let input = PaymentListViewModel.Input()
        
        let output = viewModel.transform(input: input)
     
        output.paymentListTrigger
            .drive(tableView.rx.items(cellIdentifier: PaymentListTableViewCell.identifier, cellType: PaymentListTableViewCell.self)) { index, element, cell in
                cell.productNameLabel.text = element.productName
                cell.priceLabel.text = "\(element.price.numberDecimalFormat)원"
                cell.paidAtLabel.text = "방문일: \(element.paidAt.getDateString)"
            }
            .disposed(by: disposeBag)
    }
}
