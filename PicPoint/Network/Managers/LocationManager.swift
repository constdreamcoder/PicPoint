//
//  LocationManager.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/5/24.
//

import Foundation
import MapKit
import RxSwift

final class LocationManager: CLLocationManager {
    static let shared = LocationManager()
    
    private var currentUserLocation: CLLocationCoordinate2D?
    
    private override init() {
        super.init()
        
        self.delegate = self
    }
}

extension LocationManager {
    func checkDeviceLocationAuthorization() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                
                let authorization: CLAuthorizationStatus
                
                if #available(iOS 14.0, *) {
                    authorization = self.authorizationStatus
                } else {
                    authorization = CLLocationManager.authorizationStatus()
                }
                
                DispatchQueue.main.async {
                    self.checkCurrentLocationAuthorization(status: authorization)
                }
                
            } else {
                print("위치 서비스가 꺼져 있어서, 위치 권한 요청을 할 수 없어요.")
            }
        }
    }
    
    func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("notDetermined")
            
            self.desiredAccuracy = kCLLocationAccuracyBest
            self.requestWhenInUseAuthorization()
            
        case .restricted:
            print("restricted")
        case .denied:
            NotificationCenter.default.post(name: .showLocationSettingAlert, object: nil, userInfo: ["showLocationSettingAlert": showLocationSettingAlert()])
            print("denied")
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            self.startUpdatingLocation()
        case .authorized:
            print("authorized")
        @unknown default:
            print("Error")
        }
    }
    
    func showLocationSettingAlert() -> UIAlertController {
        let alert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기 '설정>개인정보 보호'에서 위치 서비스를 켜주세요", preferredStyle: .alert)
        
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
          
            if let setting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(setting)
            } else {
                print("설정으로 가주세여~~~~~!!")
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(goSetting)
        alert.addAction(cancel)
        
        return alert
    }
    
    func getCurrentUserLocation() -> Single<CLLocationCoordinate2D> {
        return Single.create { [weak self] singleObservable in
            guard let self else { return Disposables.create() }
            if let currentUserLocation {
                singleObservable(.success(currentUserLocation))
            } else{
                singleObservable(.failure(SearchCurrentUserLocationError.failToSearchLocation))
            }
            return Disposables.create()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        
        if let coordinate = locations.last?.coordinate {
            print(coordinate)
            print(coordinate.latitude)
            print(coordinate.longitude)
            
            currentUserLocation = coordinate
        }
        
        self.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkDeviceLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
}


