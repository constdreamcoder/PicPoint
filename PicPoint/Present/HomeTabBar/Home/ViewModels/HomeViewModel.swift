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
        
        input.viewDidLoadTrigger
            .flatMap { _ in
                PostManager.fetchPostList(query: .init())
            }
            .subscribe(with: self) { owner, postListModel in
                postList.accept(postListModel.data)
            }
            .disposed(by: disposeBag)
        
        input.rightBarButtonItemTapped
            .bind(with: self) { owner, _ in
                print("검색")
            }
            .disposed(by: disposeBag)
        
        return Output(postList: postList.asDriver())
    }
}
