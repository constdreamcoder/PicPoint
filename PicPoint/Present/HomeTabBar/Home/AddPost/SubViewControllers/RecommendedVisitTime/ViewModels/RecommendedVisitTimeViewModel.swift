//
//  RecommendedVisitTimeViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/24/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol RecommendedVisitTimeViewModelDelegate: AnyObject {
    func sendRecommendedVisitTime(_ date: Date)
}

final class RecommendedVisitTimeViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    weak var delegate: RecommendedVisitTimeViewModelDelegate?
    
    init(
        delegate: RecommendedVisitTimeViewModelDelegate?
    ) {
        self.delegate = delegate
    }
    
    struct Input {
        let datePickerDateChanged: ControlEvent<Date>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        input.datePickerDateChanged
            .subscribe(with: self) { owner, date in
                print("date",date)
                owner.delegate?.sendRecommendedVisitTime(date)
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
    
}
