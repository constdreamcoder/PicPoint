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
        return textView
    }()
    
    let passwordInputTextField: CustomInputView = {
        let textView = CustomInputView("비밀번호를 입력해주세요", charLimit: 15)
        textView.titleLabel.text = "비밀번호"
        return textView
    }()
    
    let signInButton: CustomBottomButton = {
        let button = CustomBottomButton(type: .system)
        button.setTitle("로그인", for: .normal)
        return button
    }()
    
    let goToSignUpButton: CustomBottomButton = {
        let button = CustomBottomButton(type: .system)
        button.setTitle("회원가입하러 가기", for: .normal)
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
        let input = LoginViewModel.Input(
            emailText: emailInputTextView.inputTextView.rx.text.orEmpty,
            passwordText: passwordInputTextField.inputTextView.rx.text.orEmpty,
            loginButtonTapped: signInButton.rx.tap,
            goToSignUpButtonTapped: goToSignUpButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.loginValidation
            .drive(signInButton.rx.isEnabled)
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
        
    }
}
