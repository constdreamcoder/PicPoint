//
//  MyLikeViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/26/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol MyLikeViewModelDelegate: AnyObject {
    func sendMyLikeCollectionViewContentHeight(_ contentHeight: CGFloat)
}

final class MyLikeViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    weak var delegate: MyLikeViewModelDelegate?

    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
}
