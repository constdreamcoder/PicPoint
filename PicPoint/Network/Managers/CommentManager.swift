//
//  CommentManager.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/21/24.
//

import Foundation
import RxSwift
import Alamofire

struct CommentManager {
    static func writeComment(params: WriteCommentParams, body: WriteCommentBody) -> Single<Comment> {
        return Single<Comment>.create { singleObserver in
            do {
                let urlRequest = try CommentRouter.writeComment(params: params, body: body).asURLRequest()
                
                CustomSession.shared.session.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: Comment.self) { response in
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
    
    static func deleteComment(params: DeleteCommentParams) -> Single<String> {
        return Single<String>.create { singleObserver in
            do {
                let urlRequest = try CommentRouter.deleteComment(params: params).asURLRequest()
                
                CustomSession.shared.session.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .response { response in
                        switch response.result {
                        case .success:
                            singleObserver(.success(params.commentId))
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

}
