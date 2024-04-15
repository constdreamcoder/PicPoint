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
    
    let withdrawalButton: UIButton = {
        let button = UIButton()
        button.setTitle("회웥탈퇴하기", for: .normal)
        button.backgroundColor = .systemBlue
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
}

extension SettingsViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        
    }
    
    func configureConstraints() {
        view.addSubview(withdrawalButton)
        
        withdrawalButton.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .brown
    }
    
    func bind() {
        let input = SettingsViewModel.Input(
            withdrawalButtonTapped: withdrawalButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.withdrawalSuccessTrigger
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
    }
}
