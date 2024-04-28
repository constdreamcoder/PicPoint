//
//  NicknameSignUpViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NicknameSignUpViewController: BaseSignUpViewController {
    
    let nicknameInputTextView: CustomInputView = {
        let textView = CustomInputView("닉네임을 입력해주세요", charLimit: 15)
        textView.titleLabel.text = "닉네임"
        return textView
    }()
    
    private let viewModel = NicknameViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

extension NicknameSignUpViewController {
    override func configureNavigationBar() {
        super.configureNavigationBar()
        
        navigationItem.title = "닉네임 입력"
    }
    
    override func configureConstraints() {
        super.configureConstraints()
    
        baseView.addSubview(nicknameInputTextView)
        
        nicknameInputTextView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview().inset(16.0)
        }
    }
    
    override func configureUI() {
        super.configureUI()
        
        bottomButton.setTitle("다음", for: .normal)
    }
    
    override func bind() {
        super.bind()
        
        let nicknameText = nicknameInputTextView.inputTextView.rx.text.orEmpty
            .withUnretained(self)
            .map { owner, nicknameText in
                nicknameText == owner.nicknameInputTextView.textViewPlaceHolder ? "" : nicknameText
            }
        
        let input = NicknameViewModel.Input(
            nicknameText: nicknameText,
            bottomButtonTap: bottomButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.nicknameValid
            .drive(with: self) { owner, isValid in
                owner.bottomButton.backgroundColor = isValid ? .black : .systemGray5
                owner.bottomButton.isEnabled = isValid
            }
            .disposed(by: disposeBag)
        
        output.bottomButtonTapTrigger
            .drive(with: self) { owner, _ in
                let phoneNumberSignUpVC = PhoneNumberSignUpViewController()
                owner.navigationController?.pushViewController(phoneNumberSignUpVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
}
