//
//  ShowOnMapViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/6/24.
//

import Foundation
import SnapKit
import RxSwift
import RxCocoa
import CoreLocation
import UIKit

final class ShowOnMapViewModel: ViewModelType {
    
    var disposeBag = DisposeBag()
    
    let selectedPin = PublishSubject<CLLocationCoordinate2D>()
    private let postListRelay = BehaviorRelay<[Post]>(value: [])
    private let selectedPostRelay = PublishRelay<Post?>()
    
    struct Input {
        let moveToDetailVCEvent: ControlEvent<UITapGestureRecognizer>
    }
    
    struct Output {
        let showPostsOnMapTrigger: Driver<[Post]>
        let showSelectedPlaceInfoTrigger: Driver<Post?>
        let moveToDetailVCTrigger: Driver<Post?>
    }
    
    init(_ postList: [Post]) {
        Observable.just(postList)
            .subscribe(with: self) { owner, postList in
                owner.postListRelay.accept(postList)
            }
            .disposed(by: disposeBag)
    }
    
    func transform(input: Input) -> Output {
        let showSelectedPlaceInfoTrigger = PublishRelay<Post?>()
        
        selectedPin
            .withLatestFrom(postListRelay) { ($0, $1) }
            .map { selectedPin, postList -> Post? in
                return postList.filter { post in
                    if let coordinates = post.content1?.components(separatedBy: "/") {
                        let latitude = Double(coordinates[0])
                        let longitude = Double(coordinates[1])
                        
                        return selectedPin.latitude == latitude && selectedPin.longitude == longitude
                    } else {
                        return false
                    }
                }[0]
            }
            .bind(with: self) { owner, post in
                showSelectedPlaceInfoTrigger.accept(post)
                owner.selectedPostRelay.accept(post)
            }
            .disposed(by: disposeBag)
            
        let moveToDetailVCTrigger = input.moveToDetailVCEvent
            .withLatestFrom(selectedPostRelay)
           
        return Output(
            showPostsOnMapTrigger: postListRelay.asDriver(),
            showSelectedPlaceInfoTrigger: showSelectedPlaceInfoTrigger.asDriver(onErrorJustReturn: nil),
            moveToDetailVCTrigger: moveToDetailVCTrigger.asDriver(onErrorJustReturn: nil)
        )
    }
}
