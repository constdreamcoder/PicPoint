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
                
                AF.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: PostListModel.self) { response in
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
    
    static func fetchPost(params: FetchPostParams) -> Single<Post> {
        return Single<Post>.create { singleObserver in
            do {
                let urlRequest = try PostRouter.fetchPost(params: params).asURLRequest()
                
                AF.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: Post.self) { response in
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
