//
//  SignUpViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/14/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class SignUpViewController: BaseViewController {
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일을 입력해주세요"
        textField.font = .systemFont(ofSize: 16.0)
        textField.backgroundColor = .white
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력해주세요"
        textField.font = .systemFont(ofSize: 16.0)
        textField.backgroundColor = .white
        return textField
    }()
    
    // TODO: - 비밀번호 확인 TextField 생성
    
    let nickTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임을 입력해주세요"
        textField.font = .systemFont(ofSize: 16.0)
        textField.backgroundColor = .white
        return textField
    }()
    
    let phoneNumTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "휴대폰 번호를 입력해주세요 예) 01012341234"
        textField.font = .systemFont(ofSize: 16.0)
        textField.backgroundColor = .white
        return textField
    }()
    
    let birthDayTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "생년월일을 입력해주세요 예) 19000101"
        textField.font = .systemFont(ofSize: 16.0)
        textField.backgroundColor = .white
        return textField
    }()
    
    lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8.0
        stackView.distribution = .equalSpacing
        [
            emailTextField,
            passwordTextField,
            nickTextField,
            phoneNumTextField,
            birthDayTextField
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.backgroundColor = .systemBlue
        return button
    }()
    
    let viewModel = SignUpViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
    }

}

extension SignUpViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        
    }
    
    func configureConstraints() {
        [
            containerStackView,
            signUpButton
        ].forEach { view.addSubview($0) }
       
        containerStackView.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
            $0.centerY.equalTo(view).multipliedBy(0.7)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(containerStackView.snp.bottom).offset(16.0)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        
        [
            emailTextField,
            passwordTextField,
            nickTextField,
            phoneNumTextField,
            birthDayTextField
        ].forEach {
            $0.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview()
            }
        }
    }
    
    func configureUI() {
        view.backgroundColor = .green
    }
    
    func bind() {
        
        let input = SignUpViewModel.Input(
            emailText: emailTextField.rx.text.orEmpty,
            passwordText: passwordTextField.rx.text.orEmpty,
            nickText: nickTextField.rx.text.orEmpty,
            phoneNumText: phoneNumTextField.rx.text,
            birthDayText: birthDayTextField.rx.text,
            signUpButtonTapped: signUpButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.signUpValidation
            .drive(signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.signUpSuccessTrigger
            .drive(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    
}
