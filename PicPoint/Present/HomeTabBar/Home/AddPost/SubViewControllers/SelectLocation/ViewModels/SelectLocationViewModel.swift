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
    
    let eraseButtonTapped = PublishSubject<RecentKeyword>()
    let searchResultsSubject = PublishSubject<[MKLocalSearchCompletion]>()
    let selectedResultSubject = PublishSubject<MKPlacemark>()
    private let recentKeywordListRelay = BehaviorRelay<[RecentKeyword]>(value: [])
    
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
        let recentKeywordList: Driver<[RecentKeyword]>
    }
    
    init(
        delegate: SelectLocationViewModelDelegate?
    ) {
        self.delegate = delegate
    }
    
    func transform(input: Input) -> Output {
        let fetchRecentKeywordListTrigger = PublishSubject<Void>()
        
        fetchRecentKeywordListTrigger
            .bind(with: self) { owner,  _ in
                let recentKeywordList: [RecentKeyword] = RecentKeywordRepository.shared.read().sorted(byKeyPath: "regDate", ascending: false).map { $0 }
                owner.recentKeywordListRelay.accept(recentKeywordList)
            }
            .disposed(by: disposeBag)
        
        input.viewDidLoad
            .map {
                LocationManager.shared.checkDeviceLocationAuthorization()
            }
            .bind { _ in
                fetchRecentKeywordListTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        let gestureState = input.longTap
            .map { $0.state }
        
        let moveToUserTrigger = input.moveToUserButton
            .flatMap {
                LocationManager.shared.getCurrentUserLocationSingle()
            }
        
        selectedResultSubject
            .bind { selectedResult in
                let id = "\(selectedResult.coordinate.latitude)/\(selectedResult.coordinate.longitude)"
                let recentKeyword = RecentKeyword(
                    id: id,
                    keyword: selectedResult.name ?? ""
                )
                let count = RecentKeywordRepository.shared.read().filter { $0.keyword == recentKeyword.keyword }.count
                
                if count < 1 {
                    RecentKeywordRepository.shared.write(recentKeyword)

                    RecentKeywordRepository.shared.getLocationOfDefaultRealm()
                    
                    fetchRecentKeywordListTrigger.onNext(())
                }
            }
            .disposed(by: disposeBag)
        
        eraseButtonTapped
            .bind { selectedRecentKeyword in
                RecentKeywordRepository.shared.delete(selectedRecentKeyword)
                
                fetchRecentKeywordListTrigger.onNext(())
            }
            .disposed(by: disposeBag)
        
        return Output(
            gestureState: gestureState.asDriver(onErrorJustReturn: .ended),
            moveToUserButton: moveToUserTrigger.asDriver(onErrorJustReturn: CLLocationCoordinate2D()),
            searchResults: searchResultsSubject.asDriver(onErrorJustReturn: []),
            recentKeywordList: recentKeywordListRelay.asDriver(onErrorJustReturn: [])
        )
    }
}
