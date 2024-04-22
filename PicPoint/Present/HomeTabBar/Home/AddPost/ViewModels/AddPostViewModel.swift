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
        .init(items: AddPostCollectionVIewCellType.allCases)
    ]
    
    private let selectedImagesRelay = BehaviorRelay<[PHAsset]>(value: [PHAsset()])
    private let errorMessageRelay = BehaviorRelay<String>(value: "")
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let rightBarButtonItemTap: ControlEvent<Void>
        let imageCellTapSubject: PublishSubject<IndexPath>
        let imageCellButtonTapSubject: PublishSubject<Int>
    }
    
    struct Output {
        let sections: Driver<[AddPostCollectionViewSectionDataModel]>
        let rightBarButtonItemTapTrigger: Driver<Void>
        let selectedImages: Driver<[PHAsset]>
        let errorMessage: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let rightBarButtonItemTapTrigger = input.rightBarButtonItemTap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .map {
                print("눌림")
            }
        
        input.imageCellTapSubject
            .withLatestFrom(selectedImagesRelay)
            .subscribe(with: self) { owner, assets in
                if assets.count >= 6 {
                    owner.errorMessageRelay.accept("추가할 수 있는 이미지를 초과하였습니다. 최대 5개의 이미지까지만 추가 가능합니다.")
                }
            }
            .disposed(by: disposeBag)
        
        input.imageCellButtonTapSubject
            .withLatestFrom(selectedImagesRelay) {
                var temp: [PHAsset] = $1
                temp.remove(at: $0)
                return temp
            }
            .subscribe(with: self) { owner, updatedAssets in
                owner.selectedImagesRelay.accept(updatedAssets)
            }
            .disposed(by: disposeBag)
        
            
        return Output(
            sections: Observable.just(sections).asDriver(onErrorJustReturn: []),
            rightBarButtonItemTapTrigger: rightBarButtonItemTapTrigger.asDriver(onErrorJustReturn: ()),
            selectedImages: selectedImagesRelay.asDriver(), 
            errorMessage: errorMessageRelay.asDriver()
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
