//
//  PaymentManager.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/4/24.
//

import Foundation
import RxSwift
import Alamofire

struct PaymentManager {
    static func validatePayment(body: ValidatePaymentBody) -> Single<ValidatePaymentModel> {
        return Single<ValidatePaymentModel>.create { singleObserver in
            do {
                let urlRequest = try PaymentRouter.validatePayment(body: body).asURLRequest()
                
                AF.request(urlRequest, interceptor: TokenRefresher())
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: ValidatePaymentModel.self) { response in
                        switch response.result {
                        case .success(let postListModel):
                            singleObserver(.success(postListModel))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode {
                                if let commonNetworkError = CommonNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(commonNetworkError))
                                } else if let validatePaymentError = ValidatePaymentNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(validatePaymentError))
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

    static func fetchPaymentList() -> Single<[ValidatePaymentModel]> {
        return Single<[ValidatePaymentModel]>.create { singleObserver in
            do {
                let urlRequest = try PaymentRouter.fetchPaymentList.asURLRequest()
                
                AF.request(urlRequest, interceptor: TokenRefresher())
                    .validate(statusCode: 200...500)
                    .responseDecodable(of: FetchPaymentListModel.self) { response in
                        switch response.result {
                        case .success(let postListModel):
                            singleObserver(.success(postListModel.data))
                        case .failure(_):
                            if let statusCode = response.response?.statusCode {
                                if let commonNetworkError = CommonNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(commonNetworkError))
                                } else if let fatchPaymentListError = FatchPaymentListNetworkError(rawValue: statusCode) {
                                    singleObserver(.failure(fatchPaymentListError))
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

