//
//  PhoneNumberSignUpViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PhoneNumberSignUpViewController: BaseSignUpViewController {
    
    let phoneNumberInputTextView: CustomInputView = {
        let textView = CustomInputView("전화번호를 입력해주세요 (예) 01012345678", charLimit: 11)
        textView.titleLabel.text = "전화번호(옵션)"
        textView.inputTextView.keyboardType = .numberPad
        return textView
    }()
    
    private let viewModel = PhoneNumberSignUpViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension PhoneNumberSignUpViewController {
    override func configureNavigationBar() {
        super.configureNavigationBar()
        
        navigationItem.title = "전화번호 입력"
    }
    
    override func configureConstraints() {
        super.configureConstraints()
    
        baseView.addSubview(phoneNumberInputTextView)
        
        phoneNumberInputTextView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(16.0)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        bottomButton.setTitle("다음", for: .normal)
    }
    
    override func bind() {
        super.bind()
        
        let phoneNumberText = phoneNumberInputTextView.inputTextView.rx.text.orEmpty
            .withUnretained(self)
            .map { onwer, phoneNumberText in
                phoneNumberText == onwer.phoneNumberInputTextView.textViewPlaceHolder ? "" : phoneNumberText
            }
        
        let input = PhoneNumberSignUpViewModel.Input(
            phoneNumberText: phoneNumberText,
            bottomButtonTap: bottomButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.bottomButtonTapTrigger
            .drive(with: self) { owner, isValid in
                if isValid {
                    let birthdaySignUpVC = BirthDaySignUpViewController()
                    owner.navigationController?.pushViewController(birthdaySignUpVC, animated: true)
                } else {
                    owner.makeErrorAlert(title: "전화번호 형식 확인", message: "유효하지 않은 전화번호입니다.")
                }
            }
            .disposed(by: disposeBag)
    }
}
