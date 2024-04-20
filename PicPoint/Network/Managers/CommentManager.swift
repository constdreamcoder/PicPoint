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
                print("urlRequest", urlRequest.url?.absoluteString)
                
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
    
   
}
