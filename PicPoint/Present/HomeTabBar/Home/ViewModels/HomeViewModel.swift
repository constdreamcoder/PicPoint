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
    
    let dataList: [String] = [
        "오호옿오호오홍호오호옿옿",
        "오호옿오호오홍호오호옿옿",
        "오호옿오호오홍호오호옿옿",
        "오호옿오호오홍호오호옿옿",
        "오호옿오호오홍호오호옿옿",
        "오호옿오호오홍호오호옿옿",
        "오호옿오호오홍호오호옿옿",
        "오호옿오호오홍호오호옿옿",
        "오호옿오호오홍호오호옿옿",
        "오호옿오호오홍호오호옿옿",
        "오호옿오호오홍호오호옿옿",
        "오호옿오호오홍호오호옿옿",
        "오호옿오호오홍호오호옿옿"
    ]
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let rightBarButtonItemTapped: ControlEvent<Void>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        input.rightBarButtonItemTapped
            .bind(with: self) { owner, _ in
                print("검색")
            }
            .disposed(by: disposeBag)
        
        return Output()
    }
}
