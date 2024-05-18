//
//  SettingsViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/15/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SettingsViewController: BaseViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        return tableView
    }()
    
    let logoutButton: CustomBottomButton = {
        let button = CustomBottomButton()
        button.setTitle("로그아웃하기", for: .normal)
        return button
    }()
    
    let withdrawalButton: CustomBottomButton = {
        let button = CustomBottomButton()
        button.setTitle("회웥탈퇴하기", for: .normal)
        return button
    }()
    
    private let viewModel = SettingsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
    }
    
    private func makeAlertToQuestionWithdrawal(
        title: String? = nil,
        message: String? = nil,
        buttonTitle: String? = nil,
        handler: @escaping () -> Void
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelButton = UIAlertAction(title: "취소", style: .cancel)
        let withdrawalButton = UIAlertAction(title: buttonTitle, style: .destructive) { _ in
            handler()
        }
        
        alert.addAction(cancelButton)
        alert.addAction(withdrawalButton)
        
        present(alert, animated: true)
    }
}

extension SettingsViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationItem.title = "설정"
    }
    
    func configureConstraints() {
        [
            tableView,
            logoutButton,
            withdrawalButton
        ].forEach { view.addSubview($0) }
       
        tableView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(logoutButton.snp.top).offset(-16.0)
        }
        
        logoutButton.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
            $0.bottom.equalTo(withdrawalButton.snp.top).offset(-16.0)
        }
        
        withdrawalButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .white
    }
    
    func bind() {
        let logoutTrigger = PublishSubject<Void>()
        let withdrawalTrigger = PublishSubject<Void>()
        let donationDetailsCellTapped = PublishSubject<Void>()
        let myChatRoomListCellTapped = PublishSubject<Void>()
        
        let input = SettingsViewModel.Input(
            logoutButtonTapped: logoutButton.rx.tap,
            withdrawalButtonTapped: withdrawalButton.rx.tap,
            logoutTrigger: logoutTrigger,
            withdrawalTrigger: withdrawalTrigger,
            donationDetailsCellTapped: donationDetailsCellTapped,
            myChatRoomListCellTapped: myChatRoomListCellTapped
        )
        
        let output = viewModel.transform(input: input)
        
        Observable.just(SettingTableViewCellType.allCases)
            .bind(to: tableView.rx.items(cellIdentifier: SettingTableViewCell.identifier, cellType: SettingTableViewCell.self)) { index, element, cell in
                cell.titleLabel.text = element.title
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .bind { indexPath in
                if indexPath.row == SettingTableViewCellType.donationDetailsCell.index {
                    donationDetailsCellTapped.onNext(())
                } else if indexPath.row == SettingTableViewCellType.myChatRoomListCell.index {
                    myChatRoomListCellTapped.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        output.questionLogoutTrigger
            .drive(with: self) { owner, _ in
                owner.makeAlertToQuestionWithdrawal(
                    title: "로그아웃",
                    message: "정말로 로그아웃 하시겠습니까?",
                    buttonTitle: "로그아웃"
                ) {
                    logoutTrigger.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        output.questionWithdrawalTrigger
            .drive(with: self) { owner, _ in
                owner.makeAlertToQuestionWithdrawal(
                    title: "회원탈퇴",
                    message: "정말로 탈퇴하시겠습니까?",
                    buttonTitle: "탈퇴"
                ) {
                    withdrawalTrigger.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        output.successTrigger
            .drive(with: self) { owner, _ in
                print("회원탈퇴 성공")
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let signInVC = SignInViewController()
                let signInNav = UINavigationController(rootViewController: signInVC)
                
                sceneDelegate?.window?.rootViewController = signInNav
                sceneDelegate?.window?.makeKeyAndVisible()
            }
            .disposed(by: disposeBag)
        
        output.goToPaymentListVCTrigger
            .drive(with: self) { owner, paymentList in
                let paymentListVM = PaymentListViewModel(paymentList)
                let paymentListVC = PaymentListViewController(paymentListViewModel: paymentListVM)
                owner.navigationController?.pushViewController(paymentListVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.goToMyChatRoomsVCTrigger
            .drive(with: self) { owner, myChatRoomList in
                let myChatRoomsVM = MyChatRoomsViewModel()
                let myChatRoomsVC = MyChatRoomsViewController(myChatRoomsViewModel: myChatRoomsVM)
                owner.navigationController?.pushViewController(myChatRoomsVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
