//
//  LoginViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/13/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignInViewController: BaseViewController {
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일을 입력해주세요"
        textField.font = .systemFont(ofSize: 20.0)
        textField.backgroundColor = .white
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력해주세요"
        textField.font = .systemFont(ofSize: 20.0)
        textField.backgroundColor = .white
        return textField
    }()
    
    let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = .systemBlue
        return button
    }()
    
    private let viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
    }
}

extension SignInViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        
    }
    
    func configureConstraints() {
        [
            emailTextField,
            passwordTextField,
            signInButton
        ].forEach { view.addSubview($0) }
        
        emailTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(8.0)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        
        signInButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(16.0)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    func configureUI() {
        view.backgroundColor = .green
    }
    
    func bind() {
        
        
        let input = LoginViewModel.Input(
            emailText: emailTextField.rx.text.orEmpty,
            passwordText: passwordTextField.rx.text.orEmpty,
            loginButtonTapped: signInButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.loginValidation
            .drive(signInButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.loginSuccessTrigger
            .drive(with: self) { owner, _ in
                print("로그인 성공")
            }
            .disposed(by: disposeBag)
    }
}
