//
//  PaymentListViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/8/24.
//

import Foundation
import RxSwift
import RxCocoa

final class PaymentListViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    private let paymentListRelay = BehaviorRelay<[ValidatePaymentModel]>(value: [])

    struct Input {
        
    }
    
    struct Output {
        let paymentListTrigger: Driver<[ValidatePaymentModel]>
    }

    init(_ paymentList: [ValidatePaymentModel]) {
        Observable.just(paymentList)
            .bind(with: self) { owner, paymentList in
                print("paymentList", paymentList)
                owner.paymentListRelay.accept(paymentList)
            }
            .disposed(by: disposeBag)
    }
    
    func transform(input: Input) -> Output {
        
        return Output(paymentListTrigger: paymentListRelay.asDriver())
    }

}
