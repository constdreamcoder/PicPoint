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
        let textView = CustomInputView("비밀번호를 입력해주세요", charLimit: 15)
        textView.titleLabel.text = "비밀번호"
        return textView
    }()
    
    let passwordConfirmInputTextView: CustomInputView = {
        let textView = CustomInputView("비밀번호를 확인해주세요", charLimit: 15)
        textView.titleLabel.text = "비밀번호 확인"
        return textView
    }()

    let viewModel = PasswordSignUpViewModel()

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
            passwordConfirmInputTextView
        ].forEach { baseView.addSubview($0) }
        
        passwordInputTextView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(16.0)
        }
        
        passwordConfirmInputTextView.snp.makeConstraints {
            $0.top.equalTo(passwordInputTextView.snp.bottom).offset(16.0)
            $0.horizontalEdges.equalToSuperview().inset(16.0)
        }

    }
    
    override func configureUI() {
        super.configureUI()
        
        bottomButton.setTitle("다음", for: .normal)
    }
    
    override func bind() {
        super.bind()
        
        let input = PasswordSignUpViewModel.Input(
            bottomButtonTap: bottomButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.bottomButtonTapTrigger
            .drive(with: self) { owner, _ in
                let nicknameSignUpVC = NicknameSignUpViewController()
                owner.navigationController?.pushViewController(nicknameSignUpVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
