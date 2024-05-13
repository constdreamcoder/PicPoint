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

final class SelectLocationViewController: BaseViewController {
    
    private lazy var searchCompleter: MKLocalSearchCompleter = {
        let searchCompleter = MKLocalSearchCompleter()
        searchCompleter.resultTypes = .query
        searchCompleter.delegate = self
        return searchCompleter
    }()
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    let searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        
        tableView.register(SearchLocationTableViewCell.self, forCellReuseIdentifier: SearchLocationTableViewCell.identifier)
        return tableView
    }()
    
    let searchBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()
    
    let recentKeywordTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        
        tableView.register(RecentKeywordTableViewCell.self, forCellReuseIdentifier: RecentKeywordTableViewCell.identifier)
        return tableView
    }()
    
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
    
    private func addAnnotationAndShowAddress(with placeMark: MKPlacemark) {
        
        let annotation = MKPointAnnotation()

        annotation.coordinate = placeMark.coordinate
    
        mapView.addAnnotation(annotation)

        locationLabel.text = placeMark.fullAddress
        
        locationLabelContainerView.isHidden = false
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
        
        navigationItem.titleView = searchBar
    }
    
    func configureConstraints() {
        [
            mapView,
            moveToUserButtonContainerView,
            locationLabelContainerView,
            searchBaseView
        ].forEach { view.addSubview($0) }
       
        mapView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
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
        
        searchBaseView.snp.makeConstraints {
            $0.edges.equalTo(view)
        }
        [
            searchTableView,
            recentKeywordTableView
        ].forEach { searchBaseView.addSubview($0) }
       
        searchTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        recentKeywordTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
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
                onwer.moveToPoint(userLocation)
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty.asDriver()
            .drive(with: self) { owner, searchText in
                owner.searchCompleter.queryFragment = searchText
                if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    owner.viewModel?.searchResultsSubject.onNext([])
                    owner.recentKeywordTableView.isHidden = false
                } else {
                    owner.recentKeywordTableView.isHidden = true
                }
            }
            .disposed(by: disposeBag)
        
        output.searchResults
            .drive(searchTableView.rx.items(cellIdentifier: SearchLocationTableViewCell.identifier, cellType: SearchLocationTableViewCell.self)) { row, element, cell in
                cell.titleLabel.text = element.title
                cell.subTitleLabel.text = element.subtitle
            }
            .disposed(by: disposeBag)
        
        searchTableView.rx.modelSelected(MKLocalSearchCompletion.self)
            .bind(with: self) { owner, selectedResult in
                let searchReqeust = MKLocalSearch.Request(completion: selectedResult)
                let search = MKLocalSearch(request: searchReqeust)
                search.start { response, error in
                    guard error == nil else {
                        print(error.debugDescription)
                        return
                    }
                    
                    owner.removeAllAnnotations()
                    
                    guard let placeMark = response?.mapItems[0].placemark else {
                        return
                    }
                    
                    viewModel.selectedResultSubject.onNext(placeMark)
                    
                    owner.addAnnotationAndShowAddress(with: placeMark)

                    viewModel.delegate?.sendSelectedMapPointAndAddressInfos(placeMark.coordinate, placeMark)
                    owner.searchBaseView.isHidden = true
                    
                    owner.moveToPoint(placeMark.coordinate)
                    
                    owner.searchBar.endEditing(true)
                }
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.textDidBeginEditing
            .bind(with: self) { owner, _ in
                owner.searchBaseView.isHidden = false
            }
            .disposed(by: disposeBag)
        
        output.recentKeywordList
            .drive(recentKeywordTableView.rx.items(cellIdentifier: RecentKeywordTableViewCell.identifier, cellType: RecentKeywordTableViewCell.self)) { row, element, cell in
                cell.selectLocationViewModel = viewModel
                cell.bind(element)
                
                cell.recentKeywordLabel.text = element.keyword
            }
            .disposed(by: disposeBag)
        
        recentKeywordTableView.rx.modelSelected(RecentKeyword.self)
            .bind(with: self) { owner, selectedKeyword in
                owner.searchBar.text = selectedKeyword.keyword
                owner.searchCompleter.queryFragment = selectedKeyword.keyword
                owner.recentKeywordTableView.isHidden = true
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Map-Related Custom Methods
extension SelectLocationViewController {
    
    private func moveToPoint(_ coordinates: CLLocationCoordinate2D) {
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
                    
                    self.addAnnotationAndShowAddress(with: MKPlacemark(placemark: placeMark))
                    
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

extension SelectLocationViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        Observable.just(completer.results)
            .bind(with: self) { owner, results in
                owner.viewModel?.searchResultsSubject.onNext(results)
            }
            .disposed(by: disposeBag)
        
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("completer error", error.localizedDescription)
    }
}
