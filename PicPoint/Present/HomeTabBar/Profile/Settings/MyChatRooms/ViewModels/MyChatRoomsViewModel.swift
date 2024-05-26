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
    
    private let myChatRoomList = BehaviorRelay<[ChatRoom]>(value: [])

    struct Input {
        let viewWillAppear: Observable<Bool>
    }
    
    struct Output {
        let myChatRoomList: Driver<[ChatRoom]>
    }
    
    func transform(input: Input) -> Output {
        
        input.viewWillAppear
            .bind(with: self) { owner, _ in
                let chatRoomList: [ChatRoom] = ChatRoomRepository.shared.read().sorted(by: \.updatedAt, ascending: false).map { $0 }
                owner.myChatRoomList.accept(chatRoomList)
            }
            .disposed(by: disposeBag)
            
        return Output(
            myChatRoomList: myChatRoomList.asDriver()
        )
    }
}
