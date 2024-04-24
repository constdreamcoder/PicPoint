//
//  MapPreviewViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/25/24.
//

import UIKit
import SnapKit
import MapKit

final class MapPreviewViewController: BaseViewController {
    
    let mapView = MKMapView()
    
    var coordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
        addAnnotationOnMap()
    }
}

extension MapPreviewViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        
    }
    
    func configureConstraints() {
        view.addSubview(mapView)
        
        mapView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func configureUI() {
        
    }
    
    func bind() {
        
    }
}

// MARK: - Map-Related Custom Methods
private extension MapPreviewViewController {
    func addAnnotationOnMap() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        mapView.addAnnotation(annotation)
        
        moveToCenter(coordinates: coordinates)
    }
    
    func moveToCenter(coordinates: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 10_000, longitudinalMeters: 10_000)
        mapView.setRegion(region, animated: true)
    }
}

