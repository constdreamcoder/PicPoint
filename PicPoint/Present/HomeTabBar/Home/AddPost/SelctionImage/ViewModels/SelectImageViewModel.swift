//
//  SelectImageViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/22/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SelectImageViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let rightBarButtonItemTap: ControlEvent<Void>
    }
    
    struct Output {
        let rightBarButtonItemTapTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let rightBarButtonItemTapTrigger = input.rightBarButtonItemTap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .map {
                print("눌림")
            }
        return Output(
            rightBarButtonItemTapTrigger: rightBarButtonItemTapTrigger.asDriver(onErrorJustReturn: ())
        )
    }
}
