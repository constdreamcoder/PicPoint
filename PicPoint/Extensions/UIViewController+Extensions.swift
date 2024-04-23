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

extension NSObject {
    func getUIImageFromPHAsset(_ asset: PHAsset, completionHandler: @escaping (UIImage) -> Void) {
        let imageManager = PHImageManager.default()
        let targetSize = CGSize(width: 600, height: 600)
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        imageManager.requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: .aspectFit,
            options: options
        ) { image, info in
            if let image = image {
                completionHandler(image)
            }
        }
    }
}
