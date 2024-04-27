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
import Kingfisher
import PhotosUI

final class EditProfileViewController: BaseViewController {
    
    lazy var baseView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let profileImageView: ProfileImageView = {
        let imageView = ProfileImageView(frame: .zero)
        imageView.profileImageViewWidth = 120
        imageView.isUserInteractionEnabled = true
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
        let textView = CustomInputView("생년월일을 입력해주세요", charLimit: 11)
        textView.titleLabel.text = "생년월일"
        textView.remainCountLabel.isHidden = true
        textView.inputTextView.keyboardType = .numbersAndPunctuation
        return textView
    }()

    lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("프로필 수정하기", for: .normal)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 16.0
        return button
    }()
    
    private lazy var profileImageTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: nil)
        profileImageView.addGestureRecognizer(tap)
        return tap
    }()
    
    private let viewModel: EditViewModel?
    
    private var itemProviders: [NSItemProvider] = []
    
    init(editViewModel: EditViewModel?) {
        self.viewModel = editViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        bind()
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        profileImageView.removeGestureRecognizer(profileImageTap)
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
            editButton
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
        
        editButton.snp.makeConstraints {
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
        editButton.isEnabled = false
    }
    
    func bind() {
        
        let editButtonValidation = Observable.combineLatest(
            nicknameTextView.inputTextView.rx.text.orEmpty,
            phoneNumTextView.inputTextView.rx.text.orEmpty,
            birthDayTextView.inputTextView.rx.text.orEmpty
        )
            .withUnretained(self)
            .map { owner, textData in
                if textData.0 != owner.nicknameTextView.textViewPlaceHolder
                    && textData.1 != owner.phoneNumTextView.textViewPlaceHolder
                    && textData.2 != owner.birthDayTextView.textViewPlaceHolder {
                    return textData
                } else {
                    return ("", "", "")
                }
            }
        
        guard let leftBarButtonItem = navigationItem.leftBarButtonItem else { return }
        let input = EditViewModel.Input(
            leftBarButtonItemTap: leftBarButtonItem.rx.tap, 
            editButtonObservable: editButtonValidation,
            profileImageTap: profileImageTap.rx.event,
            editButtonTap: editButton.rx.tap
        )
        
        guard let viewModel else { return }
        let output = viewModel.transform(input: input)
        
        output.leftBarButtonItemTapTrigger
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.myProfile
            .drive(with: self) { owner, myProfile in
                guard let myProfile else { return }
                if let profileImage = myProfile.profileImage, !profileImage.isEmpty {
                    let url = URL(string: APIKeys.baseURL + "/\(profileImage)")
                    let placeholderImage = UIImage(systemName: "person.circle")
                    owner.profileImageView.kf.setImageWithAuthHeaders(with: url, placeholder: placeholderImage)
                }
                
                owner.nicknameTextView.inputTextView.text = myProfile.nick
                owner.phoneNumTextView.inputTextView.text = myProfile.phoneNum
                owner.birthDayTextView.inputTextView.text = myProfile.birthday
                
                [
                    owner.nicknameTextView,
                    owner.phoneNumTextView,
                    owner.birthDayTextView
                ].forEach {
                    $0.inputTextView.textColor = .black
                    $0.updateCountLabel(characterCount: $0.inputTextView.text.count)
                }
            }
            .disposed(by: disposeBag)
        
        output.editButtonValid
            .drive(with: self) { owner, isValid in
                owner.editButton.isEnabled = isValid
                owner.editButton.backgroundColor = isValid ? .black : .systemGray5
            }
            .disposed(by: disposeBag)
        
        output.profileImageTapTrigger
            .drive(with: self) { owner, _ in
                owner.presentPicker()
            }
            .disposed(by: disposeBag)
        
        output.editButtonTapTrigger
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - PHPicker-Related Methods
extension EditProfileViewController {
    private func presentPicker() {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1
        
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        
        present(imagePicker, animated: true)
    }
    
    private func displayImage() {
        guard let itemProvider = itemProviders.first else { return }
        
        if itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                guard let self else { return }
                guard error == nil else { return }
                
                guard let image = image as? UIImage else { return }
                if let viewModel {
                    guard let imageData = image.pngData() else { return }
                    viewModel.profileImageSubject.onNext(imageData)
                }
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            }
        }
    }
}

extension EditProfileViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        itemProviders = results.map(\.itemProvider)
        
        
        if !itemProviders.isEmpty {
            displayImage()
        }
    }
}
