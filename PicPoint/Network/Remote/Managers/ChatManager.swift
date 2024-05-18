//
//  ChatManager.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/17/24.
//

import Foundation
import Alamofire
import RxSwift

struct ChatManager {
    static func createRoom(body: CreateRoomBody) -> Single<CreateRoomModel>{
        return Single<CreateRoomModel>.create { singleObserver in
            do {
                let urlRequest = try ChatRouter.createRoom(body: body).asURLRequest()
                
                CustomSession.shared.session.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: CreateRoomModel.self) { response in
                        switch response.result {
                        case .success(let createRoomModel):
                            singleObserver(.success(createRoomModel))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode {
                                if let commonNetworkError = CommonNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(commonNetworkError))
                                } else if let createRoomNetworkError = CreateRoomNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(createRoomNetworkError))
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
    
    static func fetchChattingHistory(
        params: FetchChattingHistoryParams,
        query: FetchChattingHistoryQuery
    ) -> Single<ChattingListModel> {
        return Single<ChattingListModel>.create { singleObserver in
            do {
                let urlRequest = try ChatRouter
                    .fetchChattingHistory(params: params, query: query)
                    .asURLRequest()
                
                CustomSession.shared.session.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: ChattingListModel.self) { response in
                        switch response.result {
                        case .success(let chatListModel):
                            singleObserver(.success(chatListModel))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode {
                                if let commonNetworkError = CommonNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(commonNetworkError))
                                } else if let fetchChattingHistoryNetworkError = FetchChattingHistoryNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(fetchChattingHistoryNetworkError))
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
    
    static func sendChat(
        params: SendChatParams,
        body: SendChatBody
    ) -> Single<Chat> {
        return Single<Chat>.create { singleObserver in
            do {
                let urlRequest = try ChatRouter
                    .sendChat(params: params, body: body)
                    .asURLRequest()
                
                CustomSession.shared.session.request(urlRequest)
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: Chat.self) { response in
                        switch response.result {
                        case .success(let newChat):
                            singleObserver(.success(newChat))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode {
                                if let commonNetworkError = CommonNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(commonNetworkError))
                                } else if let sendChatNetworkError = SendChatNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(sendChatNetworkError))
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
