//
//  PasswordSignUpViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PasswordSignUpViewController: BaseSignUpViewController {
    
    let passwordInputTextView: CustomInputView = {
        let textView = CustomInputView("", charLimit: 15)
        textView.titleLabel.text = "비밀번호"
        textView.inputTextView.isHidden = true
        textView.inputContainerStackView.isHidden = false
        return textView
    }()
    
    let passwordConfirmInputTextView: CustomInputView = {
        let textView = CustomInputView("", charLimit: 15)
        textView.titleLabel.text = "비밀번호 확인"
        textView.inputTextView.isHidden = true
        textView.inputContainerStackView.isHidden = false
        return textView
    }()
    
    let passwordValidLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        label.numberOfLines = 2
        return label
    }()
    
    let passwordConfirmValidLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        return label
    }()
    
    private let passwordInputGuideMessageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = """
                     <비밀번호 입력조건>
                     비밀번호는 최소 8자 이상, 15자 이하, 
                     문자, 숫자, 특수문자($@$!%*?&)를
                     모두 포함되어야 합니다.
                     """
        label.textColor = .black
        return label
    }()

    private let viewModel = PasswordSignUpViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension PasswordSignUpViewController {
    override func configureNavigationBar() {
        super.configureNavigationBar()
        
        navigationItem.title = "비밀번호 입력"
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        [
            passwordInputTextView,
            passwordValidLabel,
            passwordConfirmInputTextView,
            passwordConfirmValidLabel,
            passwordInputGuideMessageLabel
        ].forEach { baseView.addSubview($0) }
        
        passwordInputTextView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(16.0)
        }
        
        passwordValidLabel.snp.makeConstraints {
            $0.top.equalTo(passwordInputTextView.snp.bottom).offset(16.0)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        
        passwordConfirmInputTextView.snp.makeConstraints {
            $0.top.equalTo(passwordValidLabel.snp.bottom).offset(24.0)
            $0.horizontalEdges.equalToSuperview().inset(16.0)
        }
        
        passwordConfirmValidLabel.snp.makeConstraints {
            $0.top.equalTo(passwordConfirmInputTextView.snp.bottom).offset(16.0)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        
        passwordInputGuideMessageLabel.snp.makeConstraints {
            $0.top.equalTo(passwordConfirmValidLabel.snp.bottom).offset(32.0)
            $0.centerX.equalToSuperview()
        }

    }
    
    override func configureUI() {
        super.configureUI()
        
        bottomButton.setTitle("다음", for: .normal)
    }
    
    override func bind() {
        super.bind()
        
        let input = PasswordSignUpViewModel.Input(
            passwordText: passwordInputTextView.passwordInputTextField.rx.text.orEmpty,
            passwordConfirmText: passwordConfirmInputTextView.passwordInputTextField.rx.text.orEmpty,
            bottomButtonTap: bottomButton.rx.tap, 
            showPasswordButtonTapped: passwordInputTextView.showPasswordButton.rx.tap,
            showPasswordConfirmButtonTapped: passwordConfirmInputTextView.showPasswordButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.passwordValidation
            .drive(with: self) { owner, validMessage in
                if Int(validMessage) != 200 {
                    owner.passwordValidLabel.text = validMessage
                    owner.passwordValidLabel.textColor = .systemRed
                } else {
                    owner.passwordValidLabel.text = "비밀번호를 올바르게 입력하였습니다"
                    owner.passwordValidLabel.textColor = .systemGreen
                }
            }
            .disposed(by: disposeBag)
        
        output.passwordConfirmValid
            .drive(with: self) { owner, validMessage in
                if Int(validMessage) != 200 {
                    owner.passwordConfirmValidLabel.text = validMessage
                    owner.passwordConfirmValidLabel.textColor = .systemRed
                } else {
                    owner.passwordConfirmValidLabel.text = "비밀번호가 일치합니다"
                    owner.passwordConfirmValidLabel.textColor = .systemGreen
                }
            }
            .disposed(by: disposeBag)
        
        output.bottomButtonValid
            .drive(with: self) { owner, isValid in
                owner.bottomButton.isEnabled = isValid
                owner.bottomButton.backgroundColor = isValid ? .black : .systemGray5
            }
            .disposed(by: disposeBag)
        
        output.bottomButtonTapTrigger
            .drive(with: self) { owner, _ in
                let nicknameSignUpVC = NicknameSignUpViewController()
                owner.navigationController?.pushViewController(nicknameSignUpVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.showPasswordButtonTrigger
            .drive(with: self) { owner, _ in
                owner.passwordInputTextView.passwordInputTextField.isSecureTextEntry.toggle()
                if owner.passwordInputTextView.passwordInputTextField.isSecureTextEntry {
                    let image = UIImage(systemName: "eye.slash")
                    owner.passwordInputTextView.showPasswordButton.setImage(image, for: .normal)
                } else {
                    let image = UIImage(systemName: "eye")
                    owner.passwordInputTextView.showPasswordButton.setImage(image, for: .normal)
                }
            }
            .disposed(by: disposeBag)
        
        output.showPasswordConfirmButtonTrigger
            .drive(with: self) { owner, _ in
                owner.passwordConfirmInputTextView.passwordInputTextField.isSecureTextEntry.toggle()

                if owner.passwordConfirmInputTextView.passwordInputTextField.isSecureTextEntry {
                    let image = UIImage(systemName: "eye.slash")
                    owner.passwordConfirmInputTextView.showPasswordButton.setImage(image, for: .normal)
                } else {
                    let image = UIImage(systemName: "eye")
                    owner.passwordConfirmInputTextView.showPasswordButton.setImage(image, for: .normal)
                }
            }
            .disposed(by: disposeBag)
    }
}
