//
//  BirthDaySignUpViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class BirthDaySignUpViewController: BaseSignUpViewController {
    
    let birthdayInputTextView: CustomInputView = {
        let textView = CustomInputView("생년월일을 입력해주세요 (예) 20241225", charLimit: 8)
        textView.titleLabel.text = "생년월일(옵션)"
        textView.inputTextView.keyboardType = .numberPad
        return textView
    }()
    
   private let viewModel = BirthDaySignUpViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension BirthDaySignUpViewController {
    override func configureNavigationBar() {
        super.configureNavigationBar()
        
        navigationItem.title = "생년월일 입력"
    }
    
    override func configureConstraints() {
        super.configureConstraints()
    
        baseView.addSubview(birthdayInputTextView)
        
        birthdayInputTextView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(16.0)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        bottomButton.setTitle("회원 가입하기", for: .normal)
    }
    
    override func bind() {
        super.bind()
                
        let birthdayText = birthdayInputTextView.inputTextView.rx.text.orEmpty
            .withUnretained(self)
            .map { onwer, birthdayText in
                birthdayText == onwer.birthdayInputTextView.textViewPlaceHolder ? "" : birthdayText
            }
        
        let input = BirthDaySignUpViewModel.Input(
            birthdayText: birthdayText,
            bottomButtonTap: bottomButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.birthdayValid
            .drive(with: self) { owner, isValid in
                if !isValid {
                    owner.makeErrorAlert(title: "생년월일 형식 확인", message: "유효하지 않은 생년월일입니다.")
                }
            }
            .disposed(by: disposeBag)
        
        output.signUpButtonTapTrigger
            .drive(with: self) { owner, _ in
                owner.navigationController?.popToRootViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
