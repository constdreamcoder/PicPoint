//
//  BaseViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/13/24.
//

import UIKit
import RxSwift
import RxCocoa
import IQKeyboardManagerSwift

class BaseViewController: UIViewController {
    
    let noContentsWarningLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 24.0, weight: .bold)
        label.textAlignment = .center
        label.isHidden = false
        return label
    }()
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = false

        view.backgroundColor = .white        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        print("deinit - \(type(of: self))")
    }
}
