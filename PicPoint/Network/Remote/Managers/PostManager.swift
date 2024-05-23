//
//  PostManager.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/16/24.
//

import Foundation
import RxSwift
import Alamofire

struct PostManager {

    static func fetchPostList(query: FetchPostsQuery) -> Single<PostListModel> {
        return Single<PostListModel>.create { singleObserver in
            do {
                let urlRequest = try PostRouter.fetchPosts(query: query).asURLRequest()
                
                CustomSession.shared.session.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: PostListModel.self) { response in
                        switch response.result {
                        case .success(let postListModel):
                            singleObserver(.success(postListModel))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode {
                                if let commonNetworkError = CommonNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(commonNetworkError))
                                } else if let fetchPostListError = FetchPostListNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(fetchPostListError))
                                } else {
                                    singleObserver(.failure(CommonNetworkError.unknownError))
                                }
                            }
                        }
                    }
            } catch {
                singleObserver(.failure(CommonNetworkError.unknownError))
            }
            return Disposables.create()
        }
    }
    
    static func fetchPost(params: FetchPostParams) -> Single<Post> {
        return Single<Post>.create { singleObserver in
            
            do {
                let urlRequest = try PostRouter.fetchPost(params: params).asURLRequest()
                                
                CustomSession.shared.session.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: Post.self) { response in
                        switch response.result {
                        case .success(let postModel):
                            singleObserver(.success(postModel))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode {
                                if let commonNetworkError = CommonNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(commonNetworkError))
                                } else if let fetchPostError = FetchPostNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(fetchPostError))
                                } else {
                                    singleObserver(.failure(CommonNetworkError.unknownError))
                                }
                            }
                        }
                    }
            } catch {
                singleObserver(.failure(CommonNetworkError.unknownError))
            }
            return Disposables.create()
        }
    }
    
    static func uploadImages(body: UploadImagesBody) -> Single<ImageFileListModel> {
        return Single<ImageFileListModel>.create { singleObserver in
            do {
                let urlRequest = try PostRouter.uploadImages(body: body).asURLRequest()
                
                guard let url = urlRequest.url else { return Disposables.create() }
                guard let method = urlRequest.method else { return Disposables.create() }
                
                let headers = urlRequest.headers
                
                CustomSession.shared.session.upload(multipartFormData: { multipartFormData in
                    body.files.forEach { imageFile in
                        multipartFormData.append(
                            imageFile.imageData,
                            withName: body.keyName,
                            fileName: imageFile.name,
                            mimeType: imageFile.mimeType.rawValue
                        )
                    }
                }, to: url, method: method, headers: headers)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: ImageFileListModel.self) { response in
                        switch response.result {
                        case .success(let postListModel):
                            singleObserver(.success(postListModel))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode {
                                if let commonNetworkError = CommonNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(commonNetworkError))
                                } else if let uploadImagesError = UploadPostImagesNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(uploadImagesError))
                                } else {
                                    singleObserver(.failure(CommonNetworkError.unknownError))
                                }
                            }
                        }
                    }
            } catch {
                singleObserver(.failure(CommonNetworkError.unknownError))
            }
            return Disposables.create()
        }
    }
 
    static func writePost(body: WritePostBody) -> Single<Post> {
        return Single<Post>.create { singleObserver in
            do {
                print()
                let urlRequest = try PostRouter.writePost(body: body).asURLRequest()
                
                CustomSession.shared.session.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: Post.self) { response in
                        switch response.result {
                        case .success(let postListModel):
                            singleObserver(.success(postListModel))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode {
                                if let commonNetworkError = CommonNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(commonNetworkError))
                                } else if let writePostError = WritePostNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(writePostError))
                                } else {
                                    singleObserver(.failure(CommonNetworkError.unknownError))
                                }
                            }
                        }
                    }
            } catch {
                singleObserver(.failure(CommonNetworkError.unknownError))
            }
            return Disposables.create()
        }
    }
    
    static func deletePost(params: DeletePostParams) -> Single<String> {
        return Single<String>.create { singleObserver in
            do {
                let urlRequest = try PostRouter.deletePost(params: params).asURLRequest()
                
                CustomSession.shared.session.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .response { response in
                        switch response.result {
                        case .success:
                            singleObserver(.success(params.postId))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode {
                                if let commonNetworkError = CommonNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(commonNetworkError))
                                } else if let deletePostError = DeletePostNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(deletePostError))
                                } else {
                                    singleObserver(.failure(CommonNetworkError.unknownError))
                                }
                            }
                        }
                    }
            } catch {
                singleObserver(.failure(CommonNetworkError.unknownError))
            }
            return Disposables.create()
        }
    }
    
    static func FetchPostWithHashTag(query: FetchPostWithHashTagQuery) -> Single<PostListModel> {
        return Single<PostListModel>.create { singleObserver in
            do {
                let urlRequest = try PostRouter.fetchPostWithHashTag(query: query).asURLRequest()
                
                CustomSession.shared.session.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: PostListModel.self) { response in
                        switch response.result {
                        case .success(let postListModel):
                            singleObserver(.success(postListModel))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode {
                                if let commonNetworkError = CommonNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(commonNetworkError))
                                } else if let searchHashTagsError = SearchHashTagsNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(searchHashTagsError))
                                } else {
                                    singleObserver(.failure(CommonNetworkError.unknownError))
                                }
                            }
                        }
                    }
            } catch {
                singleObserver(.failure(CommonNetworkError.unknownError))
            }
            return Disposables.create()
        }
    }
    
    static func updatePost(paramas: FetchPostParams, body: WritePostBody) -> Single<Post> {
        return Single<Post>.create { singleObserver in
            do {
                let urlRequest = try PostRouter.updatePost(paramas: paramas, body: body).asURLRequest()
                
                CustomSession.shared.session.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: Post.self) { response in
                        switch response.result {
                        case .success(let postListModel):
                            singleObserver(.success(postListModel))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode {
                                if let commonNetworkError = CommonNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(commonNetworkError))
                                } else if let updatePostError = UpdatePostNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(updatePostError))
                                } else {
                                    singleObserver(.failure(CommonNetworkError.unknownError))
                                }
                            }
                        }
                    }
            } catch {
                singleObserver(.failure(CommonNetworkError.unknownError))
            }
            return Disposables.create()
        }
    }
}
