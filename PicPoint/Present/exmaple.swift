//
//  exmaple.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/11/24.
//
//
//  ViewController.swift
//  SaSACWeek5
//
//  Created by SUCHAN CHANG on 1/23/24.
//

import UIKit
import CoreLocation // 1. 위치 임포트
import MapKit

/*
 Enum
 - case
 - rawValue
 - CaseIterable
 - Unfrozen Enum -> @unknown: 추후에 멤버가 추가될 가능성이 있는 열거형
 - @frozen: 열거형에서 미래에 case가 더 추가될 가능성이 없어서 얼려놓았다는 의미
 
 TMI: 프로퍼티/메서드/클래스 => Swift Attributes
 - @unknown
 - @frozen
 - @available
 - @outlet
 - @action
 - @discardableResult: return 값 무시
 - @escaping
 - @objc
 */

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var switchControl: UISwitch!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var mapView: MKMapView!
    
    // 2. 위치 매니저 생성: 위치에 대한 대부분을 담당
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 4. 위치 프로토콜 연결
        locationManager.delegate = self
        
        // 보통 locationManagerDidChangeAuthorization(_:) 이때도 디바이스 권한 체크를 수행하고, viewDidLoad에서도 디바이스 권한 체크를 수행하지만
        // 무언가 디바이스 권한 체크를 중복으로 수행하는 것 같아 viewDidLoad에서 디바이스 권한 체크 수행을 삭제해준다.
        // 왜냐하면 locationManger 생성 시 locationManagerDidChangeAuthorization(_:) 메서드가 실행되기 때문이다.
        // 하지만 해당 ViewController를 NavigationController로 감싼 후, Entry Point를 NavigationController로 변경하여 실행할 때는 실행되지 않는다.
        // 따라서 왠만하면 디바이스 권한 체크는 viewDidLoad에서 한번 더 실행해 주는 것을 권장
        checkDeviceLocationAuthorization()
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        let url = URL(string: "https://apod.nasa.gov/apod/image/2401/SeagullToCalifornia_Symon_2000.jpg")!
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            } catch {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(systemName: "star.fill")
                }
            }
        }
    }
    
}

extension ViewController {
    // 1) 사용자에게 권한을 요청하기 위해, iOS 위치 서비스 활성화 여부 체크
    func checkDeviceLocationAuthorization() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                
                // 현재 사용자의 위치 권한 상태 확인
                let authorization: CLAuthorizationStatus
                
                if #available(iOS 14.0, *) {
                    authorization = self.locationManager.authorizationStatus
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
    
    // 2) 사용자 위치 권한 상태 확인 후, 권한 요청
    func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined: // 아직 권한 결정을 한번도 안해본 상태 => 권한 문구 띄우기
            print("notDetermined")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            // info.plist에서도 whenInUseAuthorization 의 경우로 권한을 지정해주어야 한다.
            locationManager.requestWhenInUseAuthorization() // 권한 문구 띄우기
            
        case .restricted: // 자녀 보호 기능 등으로 앱의 우치 권한 상태를 변경할 수 없는 경우
            print("restricted")
        case .denied: // 허용 안함
            self.showLocationSettingAlert()
            print("denied")
        case .authorizedAlways: // 항상 허용. 앱 사용 여부랑 상관없이 위치 이벤트 수신 가능
            // 애플에서는 이 것을 프라이버시 문제로 간주하기 때문에
            // 사용자가 앱을 사용하는 동안 허용하고 어느 정도 시점이 지난 후,
            print("authorizedAlways")
        case .authorizedWhenInUse: // 앱 사용하는 동안 허용
            print("authorizedWhenInUse")
            // didUpdateLocation 메서드 실행
            locationManager.startUpdatingLocation()
        case .authorized: // 옛날 꺼
            print("authorized")
        @unknown default:
            print("Error")
        }
    }
    
    // 3) 설정으로 이동 Alert
    func showLocationSettingAlert() {
        let alert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기 '설정>개인정보 보호'에서 위치 서비스를 켜주세요", preferredStyle: .alert)
        
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            // 아이폰 설정으로 이동
            // 설정 화면에 갈지, 앱 상세 페이지까지 유도해줄지는 몰라요...
            // 1. 한번도 직접 설정에서 사용자가 앱 설정 상세 페이지까지 들어간 적이 없다면
            // 2. 막 다운 받은 앱이라서 설정 상세 페이지까지 갈 준비가 시스템적으로 안되어있거나
            // 위와 같은 두가지의 경우 자동으로 이동될 수도 있고, 아닐 수도 있다.
            
            if let setting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(setting)
            } else {
                print("설정으로 가주세여~~~~~!!")
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(goSetting)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        
        // 지도 중심 기반으로 보여질 범위 설정
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 400, longitudinalMeters: 400)
        
        mapView.setRegion(region, animated: true)
    }
}

// 3. 위치 프로토콜 선언
extension ViewController: CLLocationManagerDelegate {
    // 5. 사용자의 위치를 성공적으로 가지고 온 경우 실행
    // didUpdateLocations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        
        if let coordinate = locations.last?.coordinate {
            print(coordinate)
            print(coordinate.latitude)
            print(coordinate.longitude)
            
            // 날씨 API 호출
            setRegionAndAnnotation(center: coordinate)
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    // 6. 사용자의 위치를 가져오지 못하는 경우
    // didFailWithError
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    // 4) 사용자 권한 상태가 바뀔 때를 알려줌
    // 거부했다가 설정에서 허용으로 바꾸거나, noDetermined에서 허용을 했거나
    // 허용해서 위치를 갖고 오는 도중에 다시 설정에서 거부를 하거나
    // iOS 14이상...
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkDeviceLocationAuthorization()
    }
    
    // 4) 사용자 권한 상태가 바뀔 때를 알려줌
    // iOS 14 미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
}

