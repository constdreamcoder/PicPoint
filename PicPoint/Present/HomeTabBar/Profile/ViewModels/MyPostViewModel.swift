//
//  MyPostViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/26/24.
//

import Foundation
import RxSwift
import RxCocoa

protocol MyPostViewModelDelegate: AnyObject {
    func sendMyPostCollectionViewContentHeight(_ contentHeight: CGFloat)
}

final class MyPostViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    weak var delegate: MyPostViewModelDelegate?

    struct Input {

    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        Output()
    }
    
}
