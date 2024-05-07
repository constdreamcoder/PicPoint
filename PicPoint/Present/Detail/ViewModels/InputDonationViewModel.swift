//
//  InputDonationViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/7/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol InputDonationViewModelDelegate: AnyObject {
    func sendSelectedDonationAmount(_ amount: Int)
}

final class InputDonationViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    private let selectedDonationAmountSubject = BehaviorSubject<Int>(value: 100)
    
    weak var delegate: InputDonationViewModelDelegate?
    
    struct Input {
        let selectAmount: PublishSubject<Int>
        let selectButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let dismissInputDonationVCTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        
        input.selectAmount
            .bind(with: self) { owner, selectedAmount in
                owner.selectedDonationAmountSubject.onNext(selectedAmount)
            }
            .disposed(by: disposeBag)
        
       let dismissInputDonationVCTrigger = input.selectButtonTap
            .withLatestFrom(selectedDonationAmountSubject)
            .withUnretained(self)
            .map { owner, amount in
                owner.delegate?.sendSelectedDonationAmount(amount)
                return ()
            }
            
        return Output(dismissInputDonationVCTrigger: dismissInputDonationVCTrigger.asDriver(onErrorJustReturn: ()))
    }
    
}
