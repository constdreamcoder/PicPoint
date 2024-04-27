//
//  EditViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/27/24.
//

import Foundation
import RxSwift
import RxCocoa

struct EditViewModel: ViewModelType {

    var disposeBag = DisposeBag()

    struct Input {
        let leftBarButtonItemTap: ControlEvent<Void>
    }
    
    struct Output {
        let leftBarButtonItemTapTrigger: Driver<Void>
    }

    func transform(input: Input) -> Output {
        
        Output(
            leftBarButtonItemTapTrigger: input.leftBarButtonItemTap.asDriver()
        )
    }
}
