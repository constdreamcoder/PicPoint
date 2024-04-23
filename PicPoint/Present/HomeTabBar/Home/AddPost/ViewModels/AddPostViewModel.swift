//
//  AddPostViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/21/24.
//

import Foundation
import RxSwift
import RxCocoa
import Photos

final class AddPostViewModel: ViewModelType {
    
    private let sections: [AddPostCollectionViewSectionDataModel] = [
        .init(items: [.selectImageCell, .selectLocationCell, .recommendedVisitTimeCell, .visitDateCell, .titleCell, .contentCell])
    ]
    
    let imageCellButtonTapSubject = PublishSubject<Int>()
    let selectedImagesRelay = BehaviorRelay<[PHAsset]>(value: [PHAsset()])
    let imageCellTapSubject = PublishSubject<IndexPath>()
    let fetchPhotosTriggerSubject = PublishSubject<Void>()
    let visitDateRelay = BehaviorRelay<Date>(value: Date())
    let recommendedVisitTimeRelay = BehaviorRelay<Date>(value: Date())
    private let errorMessageRelay = BehaviorRelay<String>(value: "")
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let rightBarButtonItemTap: ControlEvent<Void>
        let itemTap: ControlEvent<AddPostCollectionViewCellType>
    }
    
    struct Output {
        let sections: Driver<[AddPostCollectionViewSectionDataModel]>
        let rightBarButtonItemTapTrigger: Driver<Void>
        let selectedImages: Driver<[PHAsset]>
        let errorMessage: Driver<String>
        let fetchPhotos: Driver<Void>
        let itemTapTrigger: Driver<(AddPostCollectionViewCellType ,Date)>
        let showTappedAsset: Driver<PHAsset>
    }
    
    func transform(input: Input) -> Output {
        let rightBarButtonItemTapTrigger = input.rightBarButtonItemTap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .map {
                print("눌림")
            }
        
        let showTappedAsset = imageCellTapSubject
            .withLatestFrom(selectedImagesRelay) { $1[$0.item] }
            
        
        imageCellButtonTapSubject
            .withLatestFrom(selectedImagesRelay) {
                var temp: [PHAsset] = $1
                temp.remove(at: $0)
                return temp
            }
            .subscribe(with: self) { owner, updatedAssets in
                owner.selectedImagesRelay.accept(updatedAssets)
            }
            .disposed(by: disposeBag)
        
        let itemTap = input.itemTap
            .withLatestFrom(visitDateRelay) { ($0, $1) }
        
        let fetchPhotosTrigger = fetchPhotosTriggerSubject
            .withLatestFrom(selectedImagesRelay)
            .withUnretained(self)
            .map { owner, assets in
                if assets.count >= 6 {
                    owner.errorMessageRelay.accept("추가할 수 있는 이미지를 초과하였습니다. 최대 5개의 이미지까지만 추가 가능합니다.")
                }
            }
            
        return Output(
            sections: Observable.just(sections).asDriver(onErrorJustReturn: []),
            rightBarButtonItemTapTrigger: rightBarButtonItemTapTrigger.asDriver(onErrorJustReturn: ()),
            selectedImages: selectedImagesRelay.asDriver(), 
            errorMessage: errorMessageRelay.asDriver(), 
            fetchPhotos: fetchPhotosTrigger.asDriver(onErrorJustReturn: ()),
            itemTapTrigger: itemTap.asDriver(onErrorJustReturn: (.none, Date())), 
            showTappedAsset: showTappedAsset.asDriver(onErrorJustReturn: PHAsset())
        )
    }
}

extension AddPostViewModel: SelectImageViewModelDelegate {
    func sendSelectedImage(asset: PHAsset) {
        Observable.just(asset)
            .withLatestFrom(selectedImagesRelay) {
                var assets = $1
                assets.append($0)
                return assets
            }
            .subscribe(with: self) { owner, newAssets in
                owner.selectedImagesRelay.accept(newAssets)
            }
            .disposed(by: disposeBag)
    }
}

extension AddPostViewModel: SelectVisitDateViewModelDelegate {
    func sendVisitDate(_ date: Date) {
        Observable.just(date)
            .subscribe(with: self) { owner, visitDate in
                owner.visitDateRelay.accept(visitDate)
            }
            .disposed(by: disposeBag)
    }
}

extension AddPostViewModel: RecommendedVisitTimeViewModelDelegate {
    func sendRecommendedVisitTime(_ date: Date) {
        Observable.just(date)
            .subscribe(with: self) { owner, recommenedtime in
                owner.recommendedVisitTimeRelay.accept(recommenedtime)
            }
            .disposed(by: disposeBag)
    }
}
