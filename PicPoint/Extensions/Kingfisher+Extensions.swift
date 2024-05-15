//
//  Kingfisher+Extensions.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/16/24.
//

import UIKit
import Kingfisher

extension KingfisherWrapper where Base: UIImageView {
    func setImageWithAuthHeaders(
        with resource: Resource?,
        placeholder: Placeholder? = nil,
        options: KingfisherOptionsInfo? = nil,
        progressBlock: DownloadProgressBlock? = nil,
        completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil
    ) {
        let imageDownloadRequest = AnyModifier { request in
            var requestBody = request
            requestBody.setValue(UserDefaultsManager.accessToken, forHTTPHeaderField: HTTPHeader.authorization.rawValue)
            requestBody.setValue(APIKeys.sesacKey, forHTTPHeaderField: HTTPHeader.sesacKey.rawValue)
            return requestBody
        }
        
        let newOptions: KingfisherOptionsInfo = options ?? [] + [.requestModifier(imageDownloadRequest), .cacheMemoryOnly]
        
        self.setImage(
            with: resource,
            placeholder: placeholder,
            options: newOptions,
            progressBlock: progressBlock,
            completionHandler: completionHandler
        )
    }
}
