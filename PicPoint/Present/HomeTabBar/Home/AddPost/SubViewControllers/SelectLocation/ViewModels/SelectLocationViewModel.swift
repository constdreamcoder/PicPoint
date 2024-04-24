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

protocol SelectLocationViewModelDelegate: AnyObject {
    func sendSelectedMapPointAndAddressInfos(_ mapPoint: CLLocationCoordinate2D, _ addressInfos: CLPlacemark)
}

final class SelectLocationViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    
    weak var delegate: SelectLocationViewModelDelegate?
    
    struct Input {
        let longTap: ControlEvent<UILongPressGestureRecognizer>
    }
    
    struct Output {
        let gestureState: Driver<UIGestureRecognizer.State>
    }
    
    init(
        delegate: SelectLocationViewModelDelegate?
    ) {
        self.delegate = delegate
    }
    
    func transform(input: Input) -> Output {
        let gestureState = input.longTap
            .map { $0.state }
        
        return Output(gestureState: gestureState.asDriver(onErrorJustReturn: .ended))
    }
}
