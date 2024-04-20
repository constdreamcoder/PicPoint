//
//  HomeViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/15/24.
//

import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: ViewModelType {

    var disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoadTrigger: Observable<Void>
        let rightBarButtonItemTapped: ControlEvent<Void>
    }
    
    struct Output {
        let postList: Driver<[Post]>
    }
    
    func transform(input: Input) -> Output {
        let postList = BehaviorRelay<[Post]>(value: [])
        
//        
        
        return Output(postList: postList.asDriver())
    }
}
