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
                
                AF.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: Comment.self) { response in
                        switch response.result {
                        case .success(let postListModel):
                            singleObserver(.success(postListModel))
                        case .failure(let AFError):
                            print(response.response?.statusCode)
                            print(AFError)
                            singleObserver(.failure(AFError))
                        }
                    }
            } catch {
                singleObserver(.failure(error))
            }
            return Disposables.create()
        }
    }
    
    static func deleteComment(params: DeleteCommentParams) -> Single<String> {
        return Single<String>.create { singleObserver in
            do {
                let urlRequest = try CommentRouter.deleteComment(params: params).asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .response { response in
                        switch response.result {
                        case .success:
                            singleObserver(.success(params.commentId))
                        case .failure(let AFError):
                            print(response.response?.statusCode)
                            print(AFError)
                            singleObserver(.failure(AFError))
                        }
                    }
            } catch {
                singleObserver(.failure(error))
            }
            return Disposables.create()
        }
    }

}
