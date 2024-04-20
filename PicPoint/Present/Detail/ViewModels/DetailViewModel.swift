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
    private let postRelay = BehaviorRelay<Post?>(value: nil)
    
    var disposeBag = DisposeBag()

    struct Input {
        let commentButtonTap: ControlEvent<Void>
    }
    
    struct Output {
        let sections: Driver<[SectionModelWrapper]>
        let post: Driver<Post?>
        let postId: Driver<String>
    }
    
    init(post: Post) {
        
        Observable.just(post)
            .subscribe(with: self) { owner, post in
                let sections: [SectionModelWrapper] = [
                    SectionModelWrapper(
                        DetailCollectionViewFirstSectionDataModel(
                            items: [.init(
                                header: "",
                                title: post.title ?? "",
                                files: post.files)
                            ]
                        )
                    ),
                    SectionModelWrapper(
                        DetailCollectionViewSecondSectionDataModel(
                            items: [.init(
                                header: "",
                                content: post.content ?? "",
                                createdAt: post.createdAt,
                                creator: post.creator)
                            ]
                        )
                    ),
                    SectionModelWrapper(
                        DetailCollectionViewThirdSectionDataModel(
                            header: "연관 장소",
                            items: ["1", "2", "3", "4", "5", "5", "5", "5"]
                        )
                    )
                ]
                owner.sectionsRelay.accept(sections)
                owner.postRelay.accept(post)
            }
            .disposed(by: disposeBag)
    }
    
    func transform(input: Input) -> Output {
        let postIdRelay = PublishRelay<String>()
        
        input.commentButtonTap
            .withLatestFrom(postRelay)
            .subscribe { post in
                print("dd")
                guard let post else { return }
                postIdRelay.accept(post.postId)
            }
            .disposed(by: disposeBag)
        
        return Output(
            sections: sectionsRelay.asDriver(onErrorJustReturn: []), 
            post: postRelay.asDriver(), 
            postId: postIdRelay.asDriver(onErrorJustReturn: "")
        )
    }
}
