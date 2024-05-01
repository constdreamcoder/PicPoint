//
//  NSObject+Extensions.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/24/24.
//

import UIKit
import Photos
import RxSwift
import RxCocoa

extension NSObject {    
    func getUIImageFromPHAsset(_ asset: PHAsset) -> UIImage {
        let imageManager = PHImageManager.default()
        let targetSize = CGSize(width: 600, height: 600)
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        var thumnail = UIImage()
        
        imageManager.requestImage(
            for: asset,
            targetSize: targetSize,
            contentMode: .aspectFit,
            options: options
        ) { image, info in
            guard let image else { return }
            thumnail = image
        }
        
        return thumnail
    }
    
    func updateHeartButtonUI(_ button: UIButton, isLike: Bool) {
        if isLike {
            let buttonImage = UIImage(systemName: "heart.fill")
            button.tintColor = .systemRed
            button.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(systemName: "heart")
            button.tintColor = .black
            button.setImage(buttonImage, for: .normal)
        }
    }
}
