//
//  SettingsViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/15/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SettingsViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    struct Input {
        let withdrawalButtonTapped: ControlEvent<Void>
    }
    
    struct Output {
        let withdrawalSuccessTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let withdrawalSuccessTrigger = PublishRelay<Void>()
        
        input.withdrawalButtonTapped
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .flatMap { _ in
                UserManager.withdraw()
            }
            .subscribe(with: self) { owner, withdrawalModel in
                UserDefaults.standard.clearAllData()
                withdrawalSuccessTrigger.accept(())
            } onError: { owner, error in
                print("회원탈퇴 오류 발생, \(error)")
            }
            .disposed(by: disposeBag)
        return Output(
            withdrawalSuccessTrigger: withdrawalSuccessTrigger.asDriver(onErrorJustReturn: ())
        )
    }
}
