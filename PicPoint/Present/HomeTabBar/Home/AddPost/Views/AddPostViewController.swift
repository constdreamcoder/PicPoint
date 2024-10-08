//
//  AddPostViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/21/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import Photos

final class AddPostViewController: BaseViewController {
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        
        tableView.register(SelectImageTableViewCell.self, forCellReuseIdentifier: SelectImageTableViewCell.identifier)
        tableView.register(SelectLocationTableViewCell.self, forCellReuseIdentifier: SelectLocationTableViewCell.identifier)
        tableView.register(RecommendedVisitTimeTableViewCell.self, forCellReuseIdentifier: RecommendedVisitTimeTableViewCell.identifier)
        tableView.register(VisitDateTableViewCell.self, forCellReuseIdentifier: VisitDateTableViewCell.identifier)
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        tableView.register(ContentTableViewCell.self, forCellReuseIdentifier: ContentTableViewCell.identifier)
        
        tableView.keyboardDismissMode = .onDrag
        
        return tableView
    }()
    
    private lazy var dataSource = RxTableViewSectionedReloadDataSource<AddPostCollectionViewSectionDataModel> { [weak self] dataSource, tableView, indexPath, item in
        guard let self else { return UITableViewCell() }
        
        if item == .selectImageCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectImageTableViewCell.identifier, for: indexPath) as? SelectImageTableViewCell else { return UITableViewCell() }
            
            cell.addPostViewModel = self.viewModel
            cell.bind()
            
            return cell
        } else if item == .selectLocationCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SelectLocationTableViewCell.identifier, for: indexPath) as? SelectLocationTableViewCell else { return UITableViewCell() }
            
            cell.addPostViewModel = viewModel
            cell.bind()
            
            return cell
        } else if item == .recommendedVisitTimeCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecommendedVisitTimeTableViewCell.identifier, for: indexPath) as? RecommendedVisitTimeTableViewCell else { return UITableViewCell() }
            
            cell.addPostViewModel = viewModel
            cell.bind()
            
            return cell
        } else if item == .visitDateCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: VisitDateTableViewCell.identifier, for: indexPath) as? VisitDateTableViewCell else { return UITableViewCell() }
            
            cell.addPostViewModel = self.viewModel
            cell.bind()
            
            return cell
        } else if item == .titleCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
            
            cell.addPostViewModel = viewModel
            cell.bind(tableView)
            
            return cell
        } else if item == .contentCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ContentTableViewCell.identifier, for: indexPath) as? ContentTableViewCell else { return UITableViewCell() }
            
            cell.addPostViewModel = viewModel
            cell.bind(tableView)
            
            return cell
        }
        return UITableViewCell()
    }
    
    private var viewModel: AddPostViewModel
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
         self.view.endEditing(true)
   }
    
    init(addPostViewModel: AddPostViewModel) {
        self.viewModel = addPostViewModel
        
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
}

extension AddPostViewController {
    @objc func leftBarButtonItemTapped(_ barButtonItem: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

extension AddPostViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationItem.title = "새 게시글 작성"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(leftBarButtonItemTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "등록", style: .plain, target: self, action: nil)
        
        navigationItem.backButtonTitle = ""
    }
    
    func configureConstraints() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        
    }
    
    func bind() {
        
        guard let rightBarButtonItem = navigationItem.rightBarButtonItem else { return }
        
        let itemTap = tableView.rx.modelSelected(AddPostCollectionViewCellType.self)
        
        let input = AddPostViewModel.Input(
            rightBarButtonItemTap: rightBarButtonItem.rx.tap, 
            itemTap: itemTap
        )
        
        let output = viewModel.transform(input: input)
        
        output.rightBarButtonItemTapTrigger
            .drive(with: self) { owner, _ in
                owner.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        output.sections
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.errorMessage
            .drive(with: self) { owner, errorMessage in
                if !errorMessage.isEmpty {
                    owner.makeErrorAlert(message: errorMessage)
                }
            }
            .disposed(by: disposeBag)
        
        output.itemTapTrigger
            .drive(with: self) { owner, value in
                if value.0 == .visitDateCell {
                    let selectVisitDateViewModel = SelectVisitDateViewModel(delegate: owner.viewModel)
                    selectVisitDateViewModel.selectedVisitDateRelay.accept(value.1)
                    let selecteVisitDateVC = SelectedVisitDateViewController(
                        selectVisitDateViewModel: selectVisitDateViewModel
                    )
                    selecteVisitDateVC.modalPresentationStyle = .overFullScreen
                    owner.present(selecteVisitDateVC, animated: true)
                } else if value.0 == .recommendedVisitTimeCell {
                    let recommendedVisitTimeViewModel = RecommendedVisitTimeViewModel(delegate: owner.viewModel)
                    let recommendedVisitTimeVC = RecommendedVisitTimeViewController(
                        recommendedVisitTimeViewModel: recommendedVisitTimeViewModel
                    )
                    recommendedVisitTimeVC.modalPresentationStyle = .overFullScreen
                    owner.present(recommendedVisitTimeVC, animated: true)
                } else if value.0 == .selectLocationCell {
                    let selectLocationViewModel = SelectLocationViewModel(delegate: owner.viewModel)
                    let selectLocationVC = SelectLocationViewController(
                        selectLocationViewModel: selectLocationViewModel
                    )
                    owner.navigationController?.pushViewController(selectLocationVC, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        output.fetchPhotos
            .drive(with: self) { owner, _ in
                owner.populatePhotos()
            }
            .disposed(by: disposeBag)
        
        output.showTappedAsset
            .drive(with: self) { owner, asset in
                let previewVC = PreviewViewController()
                previewVC.photoImage = owner.getUIImageFromPHAsset(asset)
                owner.present(previewVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.registerButtonValid
            .drive(rightBarButtonItem.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}

// MARK: - Fetch Photo Images from User Gallery
// TODO: - 추후 옮기 Manager로 빼기
extension AddPostViewController {
    
    private func showLocationSettingAlert() {
        let alert = UIAlertController(title: "", message: "사진을 첨부하려면 사진첩 접근 권한을 변경해주세요.", preferredStyle: .alert)
        
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
        
        present(alert, animated: true)
    }
    
    private func moveToSelectImageVC(with assets: [PHAsset]) {
        let selectImageVC = SelectImageViewController(
            selectImageViewModel: SelectImageViewModel(
                assets: assets,
                delegate: viewModel
            )
        )
        let selectImageNav = UINavigationController(rootViewController: selectImageVC)
        selectImageNav.modalPresentationStyle = .fullScreen
        present(selectImageNav, animated: true)
    }
    
    private func populatePhotos() {
        
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            guard let self else { return }
            switch status {
            case .notDetermined:
                print("notDetermined")
            case .restricted:
                print("restricted")
            case .denied:
                print("denied")
                DispatchQueue.main.async {
                    self.showLocationSettingAlert()
                }
            case .authorized:
                print("authorized")
                fetchPhotos()
            case .limited:
                print("limited")
                fetchPhotos()
            @unknown default:
                print("error")
            }
            
        }
    }
    
    private func getAssetFetchOptions() -> PHFetchOptions {
        let options = PHFetchOptions()
        
        let sortDescriptior = NSSortDescriptor(key: "creationDate", ascending: false)
        
        options.sortDescriptors = [sortDescriptior]
        
        return options
    }
    
    private func fetchPhotos() {
        let allPhotos = PHAsset.fetchAssets(with: .image, options: getAssetFetchOptions())
        
        var assets = [PHAsset]()
        
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects { [weak self] asset, count, stop in
                guard let self else { return }
                
                assets.append(asset)

                if count == allPhotos.count - 1 {
                    DispatchQueue.main.async {
                        self.moveToSelectImageVC(with: assets)
                    }
                }
            }
        }
    }
    
}
