//
//  SelectLocationViewModel.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/24/24.
//

import RxSwift
import RxCocoa
import UIKit
import CoreLocation
import MapKit

protocol SelectLocationViewModelDelegate: AnyObject {
    func sendSelectedMapPointAndAddressInfos(_ mapPoint: CLLocationCoordinate2D, _ addressInfos: CLPlacemark)
}

final class SelectLocationViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    let searchResults = PublishSubject<[MKLocalSearchCompletion]>()
    let selectedPin = PublishSubject<CLLocationCoordinate2D>()
    
    weak var delegate: SelectLocationViewModelDelegate?
    
    struct Input {
        let viewDidLoad: Observable<Void>
        let longTap: ControlEvent<UILongPressGestureRecognizer>
        let moveToUserButton: ControlEvent<Void>
    }
    
    struct Output {
        let gestureState: Driver<UIGestureRecognizer.State>
        let moveToUserButton: Driver<CLLocationCoordinate2D>
        let searchResults: Driver<[MKLocalSearchCompletion]>
    }
    
    init(
        delegate: SelectLocationViewModelDelegate?
    ) {
        self.delegate = delegate
    }
    
    func transform(input: Input) -> Output {
        
        input.viewDidLoad
            .bind { _ in
                LocationManager.shared.checkDeviceLocationAuthorization()
            }
            .disposed(by: disposeBag)
        
        let gestureState = input.longTap
            .map { $0.state }
        
        let moveToUserTrigger = input.moveToUserButton
            .flatMap {
                LocationManager.shared.getCurrentUserLocationSingle()
            }
        
        return Output(
            gestureState: gestureState.asDriver(onErrorJustReturn: .ended),
            moveToUserButton: moveToUserTrigger.asDriver(onErrorJustReturn: CLLocationCoordinate2D()),
            searchResults: searchResults.asDriver(onErrorJustReturn: [])
        )
    }
}
