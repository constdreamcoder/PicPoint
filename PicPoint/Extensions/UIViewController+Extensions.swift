//
//  UIViewController+Extensions.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/22/24.
//

import UIKit
import Photos

extension UIViewController {
    func makeErrorAlert(title: String? = nil, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let confirmButton = UIAlertAction(title: "확인", style: .default)

        alert.addAction(confirmButton)
        
        present(alert, animated: true)
    }
}
