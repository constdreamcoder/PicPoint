//
//  AddPostViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/21/24.
//

import Foundation
import RxSwift
import RxCocoa

final class AddPostViewModel: ViewModelType {
    
    private let sections: [AddPostCollectionViewSectionDataModel] = [
        .init(items: AddPostCollectionVIewCellType.allCases)
    ]
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let rightBarButtonItemTap: ControlEvent<Void>
    }
    
    struct Output {
        let sections: Driver<[AddPostCollectionViewSectionDataModel]>
        let rightBarButtonItemTapTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let rightBarButtonItemTapTrigger = input.rightBarButtonItemTap
            .map {
                print("눌림")
            }
        
        return Output(
            sections: Observable.just(sections).asDriver(onErrorJustReturn: []),
            rightBarButtonItemTapTrigger: rightBarButtonItemTapTrigger.asDriver(onErrorJustReturn: ())
        )
    }
}
