//
//  CachedImageManager.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/15/24.
//

import Foundation
import RxSwift
import Kingfisher
import UIKit

struct CachedImageManager {
    static func retrieveCachedImages(_ post: Post) -> Single<HashTagSearchViewModel.PostViewModel> {
        return Single<HashTagSearchViewModel.PostViewModel>.create { singleObserver in
            ImageCache.default.retrieveImage(forKey: APIKeys.baseURL + "/\(post.files[0])", options: nil) { result in
                switch result {
                case .success(let value):
                    if let image = value.image {
                        let newSizeImage = UIImage.newSizeImageWidthDownloadedResource(image: image)
                        let viewModel = HashTagSearchViewModel.PostViewModel(post: post, image: newSizeImage)
                        singleObserver(.success(viewModel))
                    } else {
                        guard let url = URL(string: APIKeys.baseURL + "/\(post.files[0])") else { return }
                        
                        let imageDownloadRequest = AnyModifier { request in
                            var requestBody = request
                            requestBody.setValue(UserDefaultsManager.accessToken, forHTTPHeaderField: HTTPHeader.authorization.rawValue)
                            requestBody.setValue(APIKeys.sesacKey, forHTTPHeaderField: HTTPHeader.sesacKey.rawValue)
                            return requestBody
                        }
                        
                        let newOptions: KingfisherOptionsInfo = [.requestModifier(imageDownloadRequest), .cacheMemoryOnly]
                        KingfisherManager.shared.retrieveImage(with: url, options: newOptions) { downloadResult in
                            switch downloadResult {
                            case .success(let downloadImage):
                                let newSizeImage = UIImage.newSizeImageWidthDownloadedResource(image: downloadImage.image)
                                let viewModel = HashTagSearchViewModel.PostViewModel(post: post, image: newSizeImage)
                                singleObserver(.success(viewModel))
                            case .failure(let failure):
                                singleObserver(.failure(failure))
                            }
                        }
                    }
                case .failure(let failure):
                    singleObserver(.failure(failure))
                }
            }
            return Disposables.create()
        }
    }

}
