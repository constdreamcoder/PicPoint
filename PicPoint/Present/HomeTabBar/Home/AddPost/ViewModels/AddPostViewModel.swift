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
import CoreLocation
import UIKit

protocol AddPostViewModelDelegate: AnyObject {
    func sendNewPost(_ post: Post)
}

final class AddPostViewModel: NSObject, ViewModelType {
    
    typealias PrepareForRegisteringPostType = (
        selectedImages: [PHAsset],
        picturePlacePoint: CLLocationCoordinate2D?,
        picturePlaceAddressInfos: CLPlacemark?,
        recommendedVisitTime: Date,
        visitDate: Date,
        titleText: String,
        contentText: String
    )
    
    private let sections: [AddPostCollectionViewSectionDataModel] = [
        .init(items: [.selectImageCell, .selectLocationCell, .recommendedVisitTimeCell, .visitDateCell, .titleCell, .contentCell])
    ]
    
    let imageCellButtonTapSubject = PublishSubject<Int>()
    let imageCellTapSubject = PublishSubject<IndexPath>()
    let fetchPhotosTriggerSubject = PublishSubject<Void>()
    
    let selectedImagesRelay = BehaviorRelay<[PHAsset]>(value: [PHAsset()])
    let picturePlacePointRelay = BehaviorRelay<CLLocationCoordinate2D?>(value: nil)
    let picturePlaceAddressInfosRelay = BehaviorRelay<CLPlacemark?>(value: nil)
    let recommendedVisitTimeRelay = BehaviorRelay<Date>(value: Date())
    let visitDateRelay = BehaviorRelay<Date>(value: Date())
    let titleTextRalay = BehaviorRelay<String>(value: "")
    let contentTextRalay = BehaviorRelay<String>(value: "")
    
    private let errorMessageRelay = BehaviorRelay<String>(value: "")
    
    var disposeBag = DisposeBag()
    
    weak var delegate: AddPostViewModelDelegate?
    
    struct Input {
        let rightBarButtonItemTap: ControlEvent<Void>
        let itemTap: ControlEvent<AddPostCollectionViewCellType>
        let endEditingTap: ControlEvent<UITapGestureRecognizer>
    }
    
    struct Output {
        let sections: Driver<[AddPostCollectionViewSectionDataModel]>
        let rightBarButtonItemTapTrigger: Driver<Void>
        let selectedImages: Driver<[PHAsset]>
        let errorMessage: Driver<String>
        let fetchPhotos: Driver<Void>
        let itemTapTrigger: Driver<(AddPostCollectionViewCellType ,Date)>
        let showTappedAsset: Driver<PHAsset>
        let registerButtonValid: Driver<Bool>
        let endEditingTrigger: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let registerButtonValid = BehaviorRelay<Bool>(value: false)
        let rightBarButtonItemTapTrigger = PublishRelay<Void>()
        
        Observable.combineLatest(
            selectedImagesRelay,
            picturePlacePointRelay,
            picturePlaceAddressInfosRelay,
            titleTextRalay,
            contentTextRalay
        ).subscribe { selectedImages, picturePlacePoint, picturePlaceAddress, titleText, contentText in
            if selectedImages.count > 1
                && picturePlacePoint != nil
                && picturePlaceAddress != nil
                && !titleText.isEmpty
                && !contentText.isEmpty {
                registerButtonValid.accept(true)
            } else {
                registerButtonValid.accept(false)
            }
        }.disposed(by: disposeBag)
        
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
        
        let prepareRegisterPost = Observable.combineLatest(
            selectedImagesRelay,
            picturePlacePointRelay,
            picturePlaceAddressInfosRelay,
            recommendedVisitTimeRelay,
            visitDateRelay,
            titleTextRalay,
            contentTextRalay
        ).map { value -> PrepareForRegisteringPostType? in
            if value.0.count > 1
                && value.1 != nil
                && value.2 != nil
                && !value.5.isEmpty
                && !value.6.isEmpty {
                return value
            } else {
                return nil
            }
        }
        
        input.rightBarButtonItemTap
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(selectedImagesRelay)
            .withUnretained(self)
            .map { owner, assets in
                assets.enumerated().compactMap { iteration in
                    if iteration.offset != 0 {
                        return owner.getUIImageFromPHAsset(iteration.element).pngData()
                    }
                    return nil
                }
            }
            .map { imageDatas -> UploadImagesBody in
                let imageFiles = imageDatas.map { imageData in
                    ImageFile(
                        imageData: imageData,
                        name: "testimage\(Int.random(in: 1...1000))",
                        mimeType: .png
                    )
                }
                return UploadImagesBody(files: imageFiles)
            }
            .flatMap { uploadImagesBody in
                PostManager.uploadImages(body: uploadImagesBody)
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<ImageFileListModel>.never()
                    }
            }
            .map { uploadedImageFileList -> [String] in
                print("이미지 업로드됨")
                print(uploadedImageFileList.files)
                return uploadedImageFileList.files
            }
            .withLatestFrom(prepareRegisterPost) { ($0, $1) }
            .map { uploadedImageFiles, elementsForRegisteringPost -> WritePostBody in
                guard let elementsForRegisteringPost else { return WritePostBody() }
                guard
                    let placePoint = elementsForRegisteringPost.picturePlacePoint,
                    let addressInfos = elementsForRegisteringPost.picturePlaceAddressInfos
                else { return WritePostBody() }
                
                let visitDate = elementsForRegisteringPost.visitDate
                let recommendedVisitTime = elementsForRegisteringPost.recommendedVisitTime
               
                let writePostBody = WritePostBody(
                    title: elementsForRegisteringPost.titleText,
                    content: elementsForRegisteringPost.contentText,
                    content1: "\(placePoint.latitude)/\(placePoint.longitude)/\(addressInfos.fullAddress)/\(addressInfos.shortAddress)",
                    content2: "\(visitDate)/\(recommendedVisitTime)",
                    product_id: APIKeys.productId,
                    files: uploadedImageFiles
                )
                return writePostBody
            }
            .flatMap {
                PostManager.writePost(body: $0)
                    .catch { error in
                        print(error.errorCode, error.errorDesc)
                        return Single<Post>.never()
                    }
            }
            .subscribe(with: self) { owner, post in
                print("게시글 업로드됨")
                owner.delegate?.sendNewPost(post)
                rightBarButtonItemTapTrigger.accept(())
                NotificationCenter.default.post(name: .sendNewPost, object: nil, userInfo: ["newPost": post])
            }
            .disposed(by: disposeBag)
        
        let endEditingTapTrigger = input.endEditingTap
            .map { _ in () }
        
        return Output(
            sections: Observable.just(sections).asDriver(onErrorJustReturn: []),
            rightBarButtonItemTapTrigger: rightBarButtonItemTapTrigger.asDriver(onErrorJustReturn: ()),
            selectedImages: selectedImagesRelay.asDriver(),
            errorMessage: errorMessageRelay.asDriver(),
            fetchPhotos: fetchPhotosTrigger.asDriver(onErrorJustReturn: ()),
            itemTapTrigger: itemTap.asDriver(onErrorJustReturn: (.none, Date())),
            showTappedAsset: showTappedAsset.asDriver(onErrorJustReturn: PHAsset()),
            registerButtonValid: registerButtonValid.asDriver(onErrorJustReturn: false), 
            endEditingTrigger: endEditingTapTrigger.asDriver(onErrorJustReturn: ())
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

extension AddPostViewModel: SelectLocationViewModelDelegate {
    func sendSelectedMapPointAndAddressInfos(_ mapPoint: CLLocationCoordinate2D, _ addressInfos: CLPlacemark) {
        Observable.just((mapPoint, addressInfos))
            .subscribe(with: self) { owner, value in
                owner.picturePlacePointRelay.accept(value.0)
                owner.picturePlaceAddressInfosRelay.accept(value.1)
            }
            .disposed(by: disposeBag)
    }
}
