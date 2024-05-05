//
//  SelectLocationViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/24/24.
//

import UIKit
import SnapKit
import MapKit
import CoreLocation
import RxSwift
import RxCocoa

// TODO: - 처음 맵 띄울 때 현재 사용자 위치 중심으로 지도 표시, 검색 기능 추가
final class SelectLocationViewController: BaseViewController {
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.setUserTrackingMode(.follow, animated: true)
        return mapView
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let locationLabelContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16.0
        view.isHidden = true
        return view
    }()
    
    private lazy var moveToUserButtonContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 48 / 2
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var moveToUserButton: UIButton = {
        let button = UIButton()
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseForegroundColor = .black
        buttonConfiguration.baseBackgroundColor = .white
        buttonConfiguration.image = UIImage(systemName: "location.circle")
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 32)
        buttonConfiguration.preferredSymbolConfigurationForImage = symbolConfig
        button.configuration = buttonConfiguration
        return button
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(presentLocationSettingAlert), name: .showLocationSettingAlert, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mapView.removeGestureRecognizer(tap)
        NotificationCenter.default.removeObserver(self, name: .showLocationSettingAlert, object: nil)
    }
}

extension SelectLocationViewController {
    @objc func presentLocationSettingAlert(notification: Notification) {
        if let userInfo = notification.userInfo,
           let locationSettingAlert = userInfo["showLocationSettingAlert"] as? UIAlertController {
            present(locationSettingAlert, animated: true)
        }
    }
}

extension SelectLocationViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
    }
    
    func configureConstraints() {
        [
            mapView,
            moveToUserButtonContainerView,
            locationLabelContainerView
        ].forEach { view.addSubview($0) }
       
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        moveToUserButtonContainerView.snp.makeConstraints {
            $0.trailing.equalTo(view.safeAreaLayoutGuide).inset(16.0)
            $0.bottom.equalTo(locationLabelContainerView.snp.top).offset(-8.0)
            $0.size.equalTo(48.0)
        }
        
        locationLabelContainerView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
        
        locationLabelContainerView.addSubview(locationLabel)
        
        locationLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16.0)
        }
        
        moveToUserButtonContainerView.addSubview(moveToUserButton)
        
        moveToUserButton.snp.makeConstraints {
            $0.center.equalTo(moveToUserButtonContainerView)
        }
    }
    
    func configureUI() {
       
    }
    
    func bind() {
        let input = SelectLocationViewModel.Input(
            viewDidLoad: Observable<Void>.just(()), 
            longTap: tap.rx.event, 
            moveToUserButton: moveToUserButton.rx.tap
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
        
        output.moveToUserButton
            .drive(with: self) { onwer, userLocation in
                onwer.moveToUser(userLocation)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Map-Related Custom Methods
extension SelectLocationViewController {
    
    private func moveToUser(_ coordinates: CLLocationCoordinate2D) {
        mapView.setCenter(coordinates, animated: true)
        
        let region = MKCoordinateRegion(
            center: coordinates,
            latitudinalMeters: 500,
            longitudinalMeters: 500
        )
        
        mapView.setRegion(region, animated: true)
    }
    
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
                    
                    self.locationLabelContainerView.isHidden = false
                    
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
