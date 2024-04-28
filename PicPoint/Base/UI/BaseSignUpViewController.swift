//
//  BaseSignUpViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BaseSignUpViewController: BaseViewController {
    
    let baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    let bottomButton = CustomBottomButton(type: .system)
    
    private let nextButtonBottonConstraintsDefaultConstant = -8.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        removeKeyboardNotifications()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension BaseSignUpViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        
        navigationController?.navigationBar.tintColor = .black
    }
    func configureConstraints() {
        
        view.addSubview(baseView)
        
        baseView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
          
        baseView.addSubview(bottomButton)
        
        bottomButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16.0)
            $0.bottom.equalToSuperview().offset(nextButtonBottonConstraintsDefaultConstant)
            $0.height.equalTo(50.0)
        }
        
    }
    
    func configureUI() {
        
    }
    
    func bind() {
        
    }
}

// MARK: - Keyboard Height Control Methods
extension BaseSignUpViewController {
    func addKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ noti: NSNotification){
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            
            // 노치 디자인이 있는 경우 safe area를 계산
            if #available(iOS 13.0, *) {
                let scenes = UIApplication.shared.connectedScenes
                let windowScene = scenes.first as? UIWindowScene
                let window = windowScene?.windows.first
                let bottomInset = window?.safeAreaInsets.bottom ?? 0
                let adjustedKeyboardHeight = keyboardHeight - bottomInset
                bottomButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-adjustedKeyboardHeight)
                }
            } else {
                bottomButton.snp.updateConstraints {
                    $0.bottom.equalToSuperview().offset(-keyboardHeight)
                }
            }
            view.layoutIfNeeded()
        }
        
    }
    
    @objc func keyboardWillHide(_ noti: NSNotification){
        bottomButton.snp.updateConstraints {
            $0.bottom.equalToSuperview().offset(nextButtonBottonConstraintsDefaultConstant)
        }
        view.layoutIfNeeded()
    }
}
