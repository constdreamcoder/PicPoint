//
//  EmailSignUpViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class EmailSignUpViewController: BaseSignUpViewController {

    let emailInputTextView: CustomInputView = {
        let textView = CustomInputView("이메일을 입력해주세요", charLimit: 30)
        textView.titleLabel.text = "이메일"
        textView.inputTextView.keyboardType = .emailAddress
        return textView
    }()
    
    let emailValidLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGreen
        return label
    }()
    
    let viewModel = EmailSignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension EmailSignUpViewController {
    
    override func configureNavigationBar() {
        super.configureNavigationBar()
        
        navigationItem.title = "이메일 입력"
    }
    
    override func configureConstraints() {
        super.configureConstraints()
        
        [
            emailInputTextView,
            emailValidLabel
        ].forEach { baseView.addSubview($0) }
        
        emailInputTextView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(16.0)
        }
        
        emailValidLabel.snp.makeConstraints {
            $0.top.equalTo(emailInputTextView.snp.bottom).offset(16.0)
            $0.horizontalEdges.equalToSuperview().inset(16.0)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        bottomButton.setTitle("다음", for: .normal)
    }
    
    override func bind() {
        super.bind()
        
        let emailText = emailInputTextView.inputTextView.rx.text.orEmpty
            .withUnretained(self)
            .map { onwer, emailText in
                emailText == onwer.emailInputTextView.textViewPlaceHolder ? "" : emailText
            }
        
        let input = EmailSignUpViewModel.Input(
            emailInputText: emailText,
            bottomButtonTap: bottomButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.bottomButtonTapTrigger
            .drive(with: self) { owner, message in
                if Int(message) == 200 {
                    let passwordSignUpVC = PasswordSignUpViewController()
                    owner.navigationController?.pushViewController(passwordSignUpVC, animated: true)
                } else {
                    owner.makeErrorAlert(title: "이메일 중복 체크", message: message)
                }
            }
            .disposed(by: disposeBag)
        
        output.emailValidation
            .drive(with: self) { owner, isValid in
                owner.emailValidLabel.text = isValid ? "올바른 이메일 형식입니다." : "올바른 이메일 형식이 아닙니다"
                owner.emailValidLabel.textColor = isValid ? .systemGreen : .systemRed
                
                owner.bottomButton.isEnabled = isValid
                owner.bottomButton.backgroundColor = isValid ? .black : .systemGray5
            }
            .disposed(by: disposeBag)
    }
}
