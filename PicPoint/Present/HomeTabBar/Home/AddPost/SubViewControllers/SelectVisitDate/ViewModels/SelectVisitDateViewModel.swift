//
//  SelectVisitDateViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/23/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol SelectVisitDateViewModelDelegate: AnyObject {
    func sendVisitDate(_ date: Date)
}

final class SelectVisitDateViewModel: ViewModelType {
    
    let selectedVisitDateRelay = BehaviorRelay<Date>(value: Date())
    
    weak var delegate: SelectVisitDateViewModelDelegate?
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let datePickerDate: ControlProperty<Date>
    }
    
    struct Output {
        let visitDate: Driver<Date>
    }
    
    init(
        delegate: SelectVisitDateViewModelDelegate?
    ) {
        self.delegate = delegate
    }
    
    func transform(input: Input) -> Output {
        input.datePickerDate
            .subscribe(with: self) { owner, visitDate in
                owner.delegate?.sendVisitDate(visitDate)
            }
            .disposed(by: disposeBag)
        
        return Output(visitDate: selectedVisitDateRelay.asDriver())
    }
}
