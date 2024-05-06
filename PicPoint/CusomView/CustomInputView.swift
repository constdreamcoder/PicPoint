//
//  CustomInputView.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/27/24.
//

import UIKit
import SnapKit

final class CustomInputView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = .systemFont(ofSize: 18.0, weight: .bold)
        return label
    }()
    
    let remainCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 16.0)
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var inputTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .lightGray
        textView.font = .systemFont(ofSize: 16.0)
        textView.isScrollEnabled = false
        textView.delegate = self
        return textView
    }()
    
    lazy var passwordInputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호를 입력해주세요"
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder = NSAttributedString(
            string: "비밀번호를 입력해주세요",
            attributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16.0),
                NSAttributedString.Key.foregroundColor : UIColor.lightGray
            ]
        )
        textField.delegate = self
        return textField
    }()
    
    let showPasswordButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "eye.slash")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: 20.0)
        button.setPreferredSymbolConfiguration(symbolConfiguration, forImageIn: .normal)
        return button
    }()
    
    lazy var inputContainerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 4.0
        stackView.distribution = .equalSpacing
        [
            passwordInputTextField,
            showPasswordButton
        ].forEach { stackView.addArrangedSubview($0) }
        stackView.isHidden = true
        return stackView
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private var charactersLimit: Int = 0
    
    var textViewPlaceHolder: String?
    
    init(_ textViewPlaceHolder: String, charLimit: Int = 0) {
        super.init(frame: .zero)
        
        configureConstraints()
        configureUI()
        
        initializeSettings(textViewPlaceHolder, charLimit: charLimit)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCountLabel(characterCount: Int) {
        remainCountLabel.text = "\(characterCount)/\(charactersLimit)"
        remainCountLabel.asColor(targetString: "\(characterCount)", color: characterCount == 0 ? .lightGray : .black)
    }
}

extension CustomInputView: UIViewConfiguration {
    func configureConstraints() {
        [
            titleLabel,
            remainCountLabel,
            inputTextView,
            inputContainerStackView,
            underlineView
        ].forEach { addSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview()
        }
        
        remainCountLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.centerY.equalTo(titleLabel)
        }
        
        inputTextView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8.0)
            $0.leading.equalTo(titleLabel)
            $0.trailing.equalTo(remainCountLabel)
            $0.height.lessThanOrEqualTo(60.0)
        }
        
        showPasswordButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        showPasswordButton.snp.makeConstraints {
            $0.width.equalTo(31.0)
            $0.height.equalTo(24.0)
        }
        
        inputContainerStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(14.0)
            $0.leading.equalTo(titleLabel).offset(4.0)
            $0.trailing.equalTo(remainCountLabel).offset(-4.0)
            $0.height.lessThanOrEqualTo(60.0)
        }
        
        underlineView.snp.makeConstraints {
            $0.height.equalTo(2.0)
            $0.top.equalTo(inputTextView.snp.bottom)
            $0.leading.trailing.equalTo(inputTextView)
            $0.bottom.equalToSuperview()
        }
    }
    
    func configureUI() {
        
    }
    
    func initializeSettings(_ textViewPlaceHolder: String, charLimit: Int) {
        self.inputTextView.text = textViewPlaceHolder
        self.textViewPlaceHolder = textViewPlaceHolder
        
        self.remainCountLabel.text = "0/\(charLimit)"
        self.charactersLimit = charLimit
    }
}

extension CustomInputView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder
            && textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && textView.textColor == .black {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
            updateCountLabel(characterCount: 0)
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let inputString = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let oldString = textView.text, let newRange = Range(range, in: oldString) else { return true }
        let newString = oldString.replacingCharacters(in: newRange, with: inputString).trimmingCharacters(in: .whitespacesAndNewlines)
        
        let characterCount = newString.count
        guard characterCount <= charactersLimit else { return false }
        updateCountLabel(characterCount: characterCount)
        
        return true
    }
}

extension CustomInputView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        inputTextView.text = textField.text
        return self.textView(inputTextView, shouldChangeTextIn: range, replacementText: string)
    }
}
