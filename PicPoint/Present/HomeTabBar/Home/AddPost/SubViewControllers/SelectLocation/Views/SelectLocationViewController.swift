//
//  SelectLocationViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/24/24.
//

import UIKit
import SnapKit
import MapKit
import RxSwift
import RxCocoa

// TODO: - 처음 맵 띄울 때 현재 사용자 위치 중심으로 지도 표시, 검색 기능 추가
final class SelectLocationViewController: BaseViewController {
    
    let mapView = MKMapView()
    let locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private var viewModel: SelectLocationViewModel?
    
    private lazy var tap: UILongPressGestureRecognizer = {
        let tap = UILongPressGestureRecognizer(target: self, action: nil)
        tap.minimumPressDuration = 0.3
        mapView.addGestureRecognizer(tap)
        
        return tap
    }()
    
    init(
        selectLocationViewModel: SelectLocationViewModel?
    ) {
        self.viewModel = selectLocationViewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mapView.removeGestureRecognizer(tap)
    }
}

extension SelectLocationViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
    }
    
    func configureConstraints() {
        [
            mapView,
            locationLabel
        ].forEach { view.addSubview($0) }
       
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        locationLabel.snp.makeConstraints {
            $0.top.leading.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    func configureUI() {
        
    }
    
    func bind() {
        let input = SelectLocationViewModel.Input(
            longTap: tap.rx.event
        )
        
        guard let viewModel else { return }
        let output = viewModel.transform(input: input)
        
        output.gestureState
            .drive(with: self) { owner, gestureState in
                if gestureState == .began {
                    owner.searchLocation(owner.getMapPoint(owner.tap))
                }
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Map-Related Custom Methods
extension SelectLocationViewController {
    
    private func getMapPoint(_ longTap: UILongPressGestureRecognizer) -> CLLocationCoordinate2D {
        let location: CGPoint = longTap.location(in: mapView)
        return mapView.convert(location, toCoordinateFrom: mapView)
    }
    
    private func searchLocation(_ point: CLLocationCoordinate2D) {
        let geocoder: CLGeocoder = CLGeocoder()
        let location = CLLocation(latitude: point.latitude, longitude: point.longitude)
        
        removeAllAnnotations()
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placeMarks, error in
            guard let self else { return }
            
            if error == nil, let marks = placeMarks {
                marks.forEach { placeMark in
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
                    
                    self.locationLabel.text =
                        """
                        \(placeMark.administrativeArea ?? "")
                        \(placeMark.locality ?? "")
                        \(placeMark.subLocality ?? "")
                        \(placeMark.thoroughfare ?? "")
                        \(placeMark.subThoroughfare ?? "")
                        """
            
                    self.mapView.addAnnotation(annotation)
                    
                    guard let viewModel = self.viewModel else { return }
                    viewModel.delegate?.sendSelectedMapPointAndAddressInfos(point, placeMark)
                }
            } else {
                locationLabel.text = "검색 실패"
            }
        }
    }
    
    private func removeAllAnnotations() {
        let allAnnotations = mapView.annotations
        mapView.removeAnnotations(allAnnotations)
    }
}
