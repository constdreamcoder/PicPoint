//
//  SelectImageViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/22/24.
//

import Foundation
import RxSwift
import RxCocoa
import Photos
import UIKit

protocol SelectImageViewModelDelegate: AnyObject {
    func sendSelectedImage(asset: PHAsset)
}

final class SelectImageViewModel: NSObject, ViewModelType {
    private let assetsRelay = BehaviorRelay<[PHAsset]>(value: [])
    private let selectedImageRelay = BehaviorRelay<PHAsset?>(value: nil)
    
    weak var delegate: SelectImageViewModelDelegate?
    
    var disposeBag = DisposeBag()
    
    struct Input {
        let dismissButtonTap: ControlEvent<Void>
        let rightBarButtonItemTap: ControlEvent<Void>
        let itemTap: ControlEvent<PHAsset>
    }
    
    struct Output {
        let dismissButtonTapTrigger: Driver<Void>
        let rightBarButtonItemTapTrigger: Driver<Bool>
        let assets: Driver<[PHAsset]>
        let selectedImage: Driver<PHAsset?>
    }
    
    init(
        assets: [PHAsset],
        delegate: SelectImageViewModelDelegate
    ) {
        self.delegate = delegate
        
        super.init()
        
        Observable<[PHAsset]>.just(assets)
            .subscribe(with: self) { owner, assets in
                owner.selectedImageRelay.accept(assets[0])
                owner.assetsRelay.accept(assets)
            }
            .disposed(by: disposeBag)
    }
    
    func transform(input: Input) -> Output {
        let rightBarButtonItemTap = input.rightBarButtonItemTap
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .withLatestFrom(selectedImageRelay) { ($0.0, $1) }
            .map { owner, asset in
                guard let asset else { return false }
                guard let imageSize = owner.getUIImageFromPHAsset(asset).pngData()?.count else { return false }
                
                if Double(imageSize) <= 5 * 1024 * 1024 {
                    owner.delegate?.sendSelectedImage(asset: asset)
                    return true
                } else {
                    return false
                }
            }
        
        input.itemTap
            .subscribe(with: self) { owner, selectedAsset in
                owner.selectedImageRelay.accept(selectedAsset)
            }
            .disposed(by: disposeBag)
    
        return Output(
            dismissButtonTapTrigger: input.dismissButtonTap.asDriver(onErrorJustReturn: ()),
            rightBarButtonItemTapTrigger: rightBarButtonItemTap.asDriver(onErrorJustReturn: false),
            assets: assetsRelay.asDriver(),
            selectedImage: selectedImageRelay.asDriver()
        )
    }
}
