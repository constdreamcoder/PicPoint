//
//  MyChatRoomsViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/18/24.
//

import Foundation
import RxSwift
import RxCocoa

final class MyChatRoomsViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    private let myChatRoomList = BehaviorRelay<[Room]>(value: [])

    struct Input {
        
    }
    
    struct Output {
        let myChatRoomList: Driver<[Room]>
    }
    
    init(_ myChatRoomList: [Room]) {
        Observable.just(myChatRoomList)
            .subscribe(with: self) { owner, myChatRoomList in
                owner.myChatRoomList.accept(myChatRoomList)
            }
            .disposed(by: disposeBag)
    }
    
    func transform(input: Input) -> Output {
        
        return Output(
            myChatRoomList: myChatRoomList.asDriver()
        )
    }
}
