//
//  SelectedPlaceDetailsViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/6/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SelectedPlaceDetailsViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    let post = PublishRelay<Post>()
    
    struct Input {
        let closeButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let files: Driver<[String]>
        let closeTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let files = post.map { $0.files }
        return Output(
            files: files.asDriver(onErrorJustReturn: []),
            closeTrigger: input.closeButtonTapped.asDriver()
        )
    }
}
