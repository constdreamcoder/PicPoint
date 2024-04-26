//
//  ProfileViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/15/24.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    let segmentControlSelectedIndexRelay = BehaviorRelay<Int>(value: 0)
    private let updateContentSizeRelay = PublishRelay<CGFloat>()

    struct Input {
        
    }
    
    struct Output {
        let sections: Driver<[SectionModelWrapper]>
        let updateContentSize: Driver<CGFloat>
    }
    
    func transform(input: Input) -> Output {
        let sections: [SectionModelWrapper] = [
            SectionModelWrapper(
                ProfileCollectionViewFirstSectionDataModel(
                    items: ["fgdsfg"]
                )
            ),
            SectionModelWrapper(
                ProfileCollectionViewSecondSectionDataModel(
                    items: ["1"]
                )
            )
        ]
        
        let sectionsObservable = Observable<[SectionModelWrapper]>.just(sections)

        return Output(
            sections: sectionsObservable.asDriver(onErrorJustReturn: []),
            updateContentSize: updateContentSizeRelay.asDriver(onErrorJustReturn: 0)
        )
    }
}

extension ProfileViewModel: MyPostViewModelDelegate {
    func sendMyPostCollectionViewContentHeight(_ contentHeight: CGFloat) {
        Observable.just(contentHeight)
            .subscribe(with: self) { owner, contentHeight in
                owner.updateContentSizeRelay.accept(contentHeight)
            }
            .disposed(by: disposeBag)
    }
}

extension ProfileViewModel: MyLikeViewModelDelegate {
    func sendMyLikeCollectionViewContentHeight(_ contentHeight: CGFloat) {
        Observable.just(contentHeight)
            .subscribe(with: self) { owner, contentHeight in
                owner.updateContentSizeRelay.accept(contentHeight)
            }
            .disposed(by: disposeBag)
    }
}
