//
//  EditProfileViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/27/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class EditProfileViewController: BaseViewController {
    
    lazy var baseView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let profileImageView: ProfileImageView = {
        let imageView = ProfileImageView(frame: .zero)
        imageView.profileImageViewWidth = 120
        return imageView
    }()
    
    var nicknameTextView: CustomInputView = {
        let textView = CustomInputView("닉네임을 입력해주세요", charLimit: 15)
        textView.titleLabel.text = "닉네임"
        return textView
    }()
    
    var phoneNumTextView: CustomInputView = {
        let textView = CustomInputView("-없이 전화번호를 입력해주세요", charLimit: 12)
        textView.titleLabel.text = "전화번호"
        textView.remainCountLabel.isHidden = true
        textView.inputTextView.keyboardType = .numberPad
        return textView
    }()
    
    var birthDayTextView: CustomInputView = {
        let textView = CustomInputView("생년월일을 입력해주세요")
        textView.titleLabel.text = "생년월일"
        textView.remainCountLabel.isHidden = true
        return textView
    }()

    lazy var bottomButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("프로필 수정하기", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 16.0
        return button
    }()
    
    private let viewModel = EditViewModel()
    
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

extension EditProfileViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationItem.title = "프로필 수정"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: nil)
    }
    
    func configureConstraints() {
        [
            profileImageView,
            nicknameTextView,
            phoneNumTextView,
            birthDayTextView,
            bottomButton
        ].forEach { baseView.addSubview($0) }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16.0)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(profileImageView.profileImageViewWidth)
        }
        
        nicknameTextView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16.0)
            $0.horizontalEdges.equalToSuperview().inset(16.0)
        }
        
        phoneNumTextView.snp.makeConstraints {
            $0.top.equalTo(nicknameTextView.snp.bottom).offset(16.0)
            $0.horizontalEdges.equalToSuperview().inset(16.0)
        }
        
        birthDayTextView.snp.makeConstraints {
            $0.top.equalTo(phoneNumTextView.snp.bottom).offset(16.0)
            $0.horizontalEdges.equalToSuperview().inset(16.0)
        }
        
        bottomButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(50.0)
        }
        
        view.addSubview(baseView)
        
        baseView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        
    }
    
    func bind() {
        
        guard let leftBarButtonItem = navigationItem.leftBarButtonItem else { return }
       
        let input = EditViewModel.Input(leftBarButtonItemTap: leftBarButtonItem.rx.tap)
        
        let output = viewModel.transform(input: input)
        
        output.leftBarButtonItemTapTrigger
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
