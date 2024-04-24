//
//  NSObject+Extensions.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/24/24.
//

import UIKit
import Photos

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
}
