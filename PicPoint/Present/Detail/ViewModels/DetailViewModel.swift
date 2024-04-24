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
import CoreLocation

final class DetailViewModel: ViewModelType {
    
    let mapViewTap = PublishRelay<CLLocationCoordinate2D>()
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
        let mapViewTapTrigger: Driver<CLLocationCoordinate2D>
    }
    
    init(post: Post) {
        Observable.just(post)
            .subscribe(with: self) { owner, post in
                let separatedLocationStrings = post.content1?.components(separatedBy: "/")
                
                let latitude = Double(separatedLocationStrings?[0] ?? "") ?? 0
                let longitude = Double(separatedLocationStrings?[1] ?? "") ?? 0
                
                let separatedDateStrings = post.content2?.components(separatedBy: "/")
                
                let sections: [SectionModelWrapper] = [
                    SectionModelWrapper(
                        DetailCollectionViewFirstSectionDataModel(
                            items: [.init(
                                header: "",
                                title: post.title ?? "", 
                                address: separatedLocationStrings?[3] ?? "",
                                files: post.files)
                            ]
                        )
                    ),
                    SectionModelWrapper(
                        DetailCollectionViewSecondSectionDataModel(
                            items: [.init(
                                header: "",
                                content: post.content ?? "",
                                visitDate: separatedDateStrings?[0].getDateString ?? "",
                                creator: post.creator)
                            ]
                        )
                    ),
                    SectionModelWrapper(
                        DetailCollectionViewThirdSectionDataModel(
                            header: "",
                            items: [.init(
                                header: "",
                                latitude: latitude,
                                longitude: longitude,
                                longAddress: separatedLocationStrings?[2] ?? "",
                                hashTags: post.hashTags)
                            ]
                        )
                    ),
                    SectionModelWrapper(
                        DetailCollectionViewForthSectionDataModel(
                            header: "연관장소",
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
                guard let post else { return }
                postIdRelay.accept(post.postId)
            }
            .disposed(by: disposeBag)
        
        return Output(
            sections: sectionsRelay.asDriver(onErrorJustReturn: []), 
            post: postRelay.asDriver(), 
            postId: postIdRelay.asDriver(onErrorJustReturn: ""), 
            mapViewTapTrigger: mapViewTap.asDriver(onErrorJustReturn: CLLocationCoordinate2D())
        )
    }
}
