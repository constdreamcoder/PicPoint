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
        
        baseView.addSubview(emailInputTextView)
        
        emailInputTextView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(16.0)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        bottomButton.setTitle("다음", for: .normal)
    }
    
    override func bind() {
        super.bind()

        let input = EmailSignUpViewModel.Input(
            bottomButtonTap: bottomButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.bottomButtonTapTrigger
            .drive(with: self) { owner, _ in
                let passwordSignUpVC = PasswordSignUpViewController()
                owner.navigationController?.pushViewController(passwordSignUpVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
