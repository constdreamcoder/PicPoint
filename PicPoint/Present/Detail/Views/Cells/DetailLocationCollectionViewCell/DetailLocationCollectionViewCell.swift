//
//  DetailLocationCollectionViewCell.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/25/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import MapKit

final class DetailLocationCollectionViewCell: BaseCollectionViewCell {
    
    let mapView = MKMapView()
    
    private let mapViewCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let recommendedVisitTimeView: RowView = {
        let view = RowView()
        view.iconImageView.image = UIImage(systemName: "clock")
        view.contentLabel.text = ""
        return view
    }()
    
    let locationView: RowView = {
        let view = RowView()
        view.iconImageView.image = UIImage(systemName: "location")
        view.contentLabel.text = ""
        return view
    }()
    
    let hashTagsView: RowView = {
        let view = RowView()
        view.iconImageView.image = UIImage(systemName: "number")
        view.contentLabel.text = ""
        return view
    }()
    
    lazy var containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16.0
        stackView.distribution = .equalSpacing
        [
            recommendedVisitTimeView,
            locationView,
            hashTagsView
        ].forEach { stackView.addArrangedSubview($0) }
        return stackView
    }()
    
    private lazy var tap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: nil)
        mapViewCoverView.addGestureRecognizer(tap)
        
        return tap
    }()
    
    weak var detailViewModel: DetailViewModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    deinit {
        mapViewCoverView.removeGestureRecognizer(tap)
    }
    
    func updateThirdSectionDatas(_ cellData: ThirdSectionCellData) {
        addAnnotationOnMap(latitude: cellData.latitude, longitude: cellData.longitude)
        
        recommendedVisitTimeView.contentLabel.text = cellData.recommendedVisitTime.convertToDateType?.convertToTimeString
        locationView.contentLabel.text = cellData.longAddress
        hashTagsView.contentLabel.text = String.convertToStringWithHashtags(cellData.hashTags)
    }
}

extension DetailLocationCollectionViewCell {
    override func configureConstraints() {
        super.configureConstraints()
        
        [
            mapView,
            mapViewCoverView,
            containerStackView
        ].forEach { contentView.addSubview($0) }
        
        mapView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
            $0.height.equalTo(150.0)
        }
        
        mapViewCoverView.snp.makeConstraints {
            $0.edges.equalTo(mapView)
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(mapView.snp.bottom).offset(16.0)
            $0.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(16.0)
        }
        
    }
    
    override func configureUI() {
        super.configureUI()
        
    }
    
    func bind(_ cellData: ThirdSectionCellData) {
        guard let detailViewModel else { return }
        
        let coordinates = CLLocationCoordinate2D(latitude: cellData.latitude, longitude: cellData.longitude)
        
        Observable.combineLatest(
            Observable<CLLocationCoordinate2D>.just(coordinates),
            tap.rx.event
        ).bind(with: self) { owner, value in
            detailViewModel.mapViewTapRelay.accept(value.0)
        }
        .disposed(by: disposeBag)
    }
}

// MARK: - Map-Related Custom Methods
private extension DetailLocationCollectionViewCell {
    func addAnnotationOnMap(latitude: Double = 0, longitude: Double = 0) {
        let annotation = MKPointAnnotation()
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
        
        moveToCenter(coordinates: coordinates)
    }
    
    func moveToCenter(coordinates: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 10_000, longitudinalMeters: 10_000)
        mapView.setRegion(region, animated: true)
    }
}
