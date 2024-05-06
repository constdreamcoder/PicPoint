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
    
    let emailInputTextView: CustomInputView = {
        let textView = CustomInputView("이메일을 입력해주세요", charLimit: 30)
        textView.titleLabel.text = "이메일"
        textView.inputTextView.keyboardType = .emailAddress
        textView.remainCountLabel.isHidden = true
        return textView
    }()
    
    let passwordInputTextField: CustomInputView = {
        let textView = CustomInputView("비밀번호를 입력해주세요", charLimit: 15)
        textView.titleLabel.text = "비밀번호"
        textView.remainCountLabel.isHidden = true
        textView.inputTextView.isHidden = true
        textView.inputContainerStackView.isHidden = false
        return textView
    }()
    
    let signInButton: CustomBottomButton = {
        let button = CustomBottomButton(type: .system)
        button.setTitle("로그인", for: .normal)
        return button
    }()
    
    let goToSignUpButton: CustomBottomButton = {
        let button = CustomBottomButton(type: .system)
        button.setTitle("회원가입", for: .normal)
        button.backgroundColor = .lightGray
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension SignInViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationItem.backButtonTitle = "뒤로가기"
    }
    
    func configureConstraints() {
        [
            emailInputTextView,
            passwordInputTextField,
            signInButton,
            goToSignUpButton
        ].forEach { view.addSubview($0) }
        
        emailInputTextView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        
        passwordInputTextField.snp.makeConstraints {
            $0.top.equalTo(emailInputTextView.snp.bottom).offset(24.0)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        
        signInButton.snp.makeConstraints {
            $0.top.equalTo(passwordInputTextField.snp.bottom).offset(36.0)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        
        goToSignUpButton.snp.makeConstraints {
            $0.top.equalTo(signInButton.snp.bottom).offset(16.0)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    func configureUI() {
        
    }
    
    func bind() {
        let emailText = emailInputTextView.inputTextView.rx.text.orEmpty
            .withUnretained(self)
            .map { owner, emailText in
                if  owner.emailInputTextView.inputTextView.text == owner.emailInputTextView.textViewPlaceHolder {
                    return ""
                } else {
                    return emailText
                }
            }
        
        let passwordText = passwordInputTextField.passwordInputTextField.rx.text.orEmpty
        
        let input = LoginViewModel.Input(
            emailText: emailText,
            passwordText: passwordText,
            loginButtonTapped: signInButton.rx.tap,
            goToSignUpButtonTapped: goToSignUpButton.rx.tap,
            showPasswordButtonTapped: passwordInputTextField.showPasswordButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.loginValidation
            .drive(with: self) { owner, isValid in
                owner.signInButton.isEnabled = isValid
                owner.signInButton.backgroundColor = isValid ? .black : .darkGray
            }
            .disposed(by: disposeBag)
        
        output.loginSuccessTrigger
            .drive(with: self) { owner, _ in
                print("로그인 성공")
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                
                let homeTabBarVC = HomeTabBarViewController()
                
                sceneDelegate?.window?.rootViewController = homeTabBarVC
                sceneDelegate?.window?.makeKeyAndVisible()
            }
            .disposed(by: disposeBag)
        
        output.moveToSignUpVC
            .drive(with: self) { owner, _ in
                let emailSignUpVC = EmailSignUpViewController()
                owner.navigationController?.pushViewController(emailSignUpVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.loginFailTrigger
            .drive(with: self) { owner, errorMessage in
                owner.makeErrorAlert(title: "로그인 오류", message: errorMessage)
            }
            .disposed(by: disposeBag)
        
        output.showPasswordButtonTrigger
            .drive(with: self) { owner, _ in
                owner.passwordInputTextField.passwordInputTextField.isSecureTextEntry.toggle()
                if owner.passwordInputTextField.passwordInputTextField.isSecureTextEntry {
                    let image = UIImage(systemName: "eye.slash")
                    owner.passwordInputTextField.showPasswordButton.setImage(image, for: .normal)
                } else {
                    let image = UIImage(systemName: "eye")
                    owner.passwordInputTextField.showPasswordButton.setImage(image, for: .normal)
                }
            }
            .disposed(by: disposeBag)
    }
}
