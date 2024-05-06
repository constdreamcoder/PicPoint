//
//  ShowOnMapViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/6/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import MapKit

final class ShowOnMapViewController: BaseViewController {
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.delegate = self
        return mapView
    }()
    
    let selectedPlaceDetailsView: SelectedPlaceDetailsView = {
        let view = SelectedPlaceDetailsView()
        view.isHidden = true
        return view
    }()
    
    private let viewModel: ShowOnMapViewModel
    
    private lazy var moveToDetailTap: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: nil)
        selectedPlaceDetailsView.addGestureRecognizer(tap)
        return tap
    }()

    init(showOnMapViewModel: ShowOnMapViewModel) {
        self.viewModel = showOnMapViewModel
        
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
    
    deinit {
        selectedPlaceDetailsView.removeGestureRecognizer(moveToDetailTap)
    }
}

extension ShowOnMapViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationItem.title = "뚜벅이의 방문 공간"
        tabBarController?.tabBar.isHidden = true
    }
    
    func configureConstraints() {
        [
            mapView,
            selectedPlaceDetailsView
        ].forEach { view.addSubview($0) }
       
        mapView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
        
        selectedPlaceDetailsView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(16.0)
        }
    }
    
    func configureUI() {
        
    }
    
    func bind() {
        
        let input = ShowOnMapViewModel.Input(
            moveToDetailVCEvent: moveToDetailTap.rx.event
        )
        
        let output = viewModel.transform(input: input)
        
        output.showPostsOnMapTrigger
            .drive(with: self) { owner, postList in
                postList.forEach { post in
                    owner.createAnnotaion(post)
                }
            }
            .disposed(by: disposeBag)
        
        output.showSelectedPlaceInfoTrigger
            .drive(with: self) { owner, selectedPost in
                if let selectedPost {
                    owner.selectedPlaceDetailsView.titleLabel.text = selectedPost.title
                    let shortAddress = selectedPost.content1?.components(separatedBy: "/")[3]
                    owner.selectedPlaceDetailsView.addressLabel.text = shortAddress
                    owner.selectedPlaceDetailsView.viewModel.post.accept(selectedPost)
                    owner.selectedPlaceDetailsView.isHidden = false
                }
            }
            .disposed(by: disposeBag)
        
        output.moveToDetailVCTrigger
            .drive(with: self) { owner, selectedPost in
                guard let selectedPost else { return }
                let detailVM = DetailViewModel(post: selectedPost)
                let detailVC = DetailViewController(detailViewModel: detailVM)
                owner.navigationController?.pushViewController(detailVC, animated: true)
            }
            .disposed(by: disposeBag)
            
    }
}

extension ShowOnMapViewController {
    func createAnnotaion(_ post: Post) {
        guard let content1List = post.content1?.components(separatedBy: "/") else { return }
        let latitude = Double(content1List[0])
        let longitude = Double(content1List[1])
        
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = CLLocationCoordinate2D(
            latitude: latitude ?? 0,
            longitude: longitude ?? 0
        )
        annotation.title = post.title
        
        mapView.addAnnotation(annotation)
    }
}

extension ShowOnMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
        Observable.just(annotation)
            .bind(with: self) { owner, selectedAnnotation in
                owner.viewModel.selectedPin.onNext(selectedAnnotation.coordinate)
            }
            .disposed(by: disposeBag)
    }
}
