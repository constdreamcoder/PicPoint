//
//  DetailViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/17/24.
//

import Foundation
import RxSwift
import RxCocoa
import Differentiator

final class DetailViewModel: ViewModelType {
    
    private let sectionsRelay = BehaviorRelay<[SectionModelWrapper]>(value: [])
    
    var disposeBag = DisposeBag()

    struct Input {
        
    }
    
    struct Output {
        let sections: Driver<[SectionModelWrapper]>
    }
    
    init(post: Post) {
        
        Observable.just(post)
            .subscribe(with: self) { owner, post in
                let sections: [SectionModelWrapper] = [
                    SectionModelWrapper(
                        DetailCollectionViewFirstSectionDataModel(
                            header: "",
                            items: [.init(
                                title: post.title ?? "",
                                files: post.files)
                            ]
                        )
                    ),
                    SectionModelWrapper(
                        DetailCollectionViewSecondSectionDataModel(
                            header: "",
                            items: [.init(
                                content: post.content ?? "",
                                createdAt: post.createdAt,
                                creator: post.creator)
                            ]
                        )
                    ),
                    SectionModelWrapper(
                        DetailCollectionViewThirdSectionDataModel(
                            header: "",
                            items: ["1", "2", "3", "4", "5"]
                        )
                    )
                ]
                owner.sectionsRelay.accept(sections)
            }
            .disposed(by: disposeBag)
    }
    
    func transform(input: Input) -> Output {
        
        return Output(
            sections: sectionsRelay.asDriver(onErrorJustReturn: [])
        )
    }
}
