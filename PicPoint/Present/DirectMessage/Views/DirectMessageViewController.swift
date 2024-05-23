//
//  DirectMessageViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/16/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import Kingfisher
import PhotosUI

final class DirectMessageViewController: BaseViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        
        tableView.register(OpponentDirectMessageTableViewCell.self, forCellReuseIdentifier: OpponentDirectMessageTableViewCell.identifier)
        tableView.register(MyDirectMessageTableViewCell.self, forCellReuseIdentifier: MyDirectMessageTableViewCell.identifier)
        
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    private let chatWritingSectionView: TextWritingSectionView = {
        let textWritingSectionView = TextWritingSectionView("")
        textWritingSectionView.addImagesButton.isHidden = false
        return textWritingSectionView
    }()
    
    private let viewModel: DirectMessageViewModel
    
    private let dataSource = RxTableViewSectionedReloadDataSource<DirectMessageTableViewSectionDataModel>(
        configureCell: { dataSource, tableView, indexPath, item in
            
            if item.sender.userId == UserDefaultsManager.userId {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: MyDirectMessageTableViewCell.identifier, for: indexPath) as? MyDirectMessageTableViewCell else { return UITableViewCell() }
                
                cell.updateCellDatas(item)
                
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: OpponentDirectMessageTableViewCell.identifier, for: indexPath) as? OpponentDirectMessageTableViewCell else { return UITableViewCell() }
                
                cell.updateCellDatas(item)
                
                return cell
            }
        })
    
    init(directMessageViewModel: DirectMessageViewModel) {
        self.viewModel = directMessageViewModel
        
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
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SocketIOManager.shared.leaveConnection()
        SocketIOManager.shared.removeAllEventHandlers()
    }
}

extension DirectMessageViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        
    }
    
    func configureConstraints() {
        [
            tableView,
            chatWritingSectionView
        ].forEach { view.addSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        chatWritingSectionView.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureUI() {
        
    }
    
    func bind() {
        
        let textView = chatWritingSectionView.textView
        
        let chattingText = textView.rx.text.orEmpty
            .withUnretained(self)
            .map { owner, chattingText in
                if chattingText == owner.chatWritingSectionView.textViewPlaceHolder {
                    return ""
                } else {
                    return chattingText
                }
            }
        
        let input = DirectMessageViewModel.Input(
            chattingTextEvent: chattingText,
            didBeginEditing: textView.rx.didBeginEditing,
            didEndEditing: textView.rx.didEndEditing,
            sendButtonTap: chatWritingSectionView.sendButton.rx.tap,
            addImagesButtonTap: chatWritingSectionView.addImagesButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.sections
            .drive(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.sections
            .drive(with: self) { owner, sections in
                let itemCount = sections[0].items.count
                guard itemCount > 0 else { return }
                let index = itemCount - 1
                owner.tableView.scrollToRow(
                    at: IndexPath(row: index, section: 0), at: .bottom, animated: true)
            }
            .disposed(by: disposeBag)
        
        output.chattingText
            .drive(with: self) { owner, commentText in
                let textVeiw = owner.chatWritingSectionView.textView
                let size = CGSize(
                    width: textVeiw.frame.size.width,
                    height: .infinity
                )
                let estimatedSize = textVeiw.sizeThatFits(size)
                
                guard textVeiw.contentSize.height < 100.0 else {
                    textVeiw.isScrollEnabled = true
                    return
                }
                
                textVeiw.isScrollEnabled = false
                textVeiw.constraints.forEach { constraint in
                    if constraint.firstAttribute == .height {
                        constraint.constant = estimatedSize.height
                    }
                }
            }
            .disposed(by: disposeBag)
        
        output.chattingDidBeginEditingTrigger
            .drive(with: self) { owner, _ in
                if textView.text == owner.chatWritingSectionView.textViewPlaceHolder
                    && textView.textColor == .lightGray {
                    textView.text = nil
                    textView.textColor = .black
                }
            }
            .disposed(by: disposeBag)
        
        output.chattingDidEndEditingTrigger
            .drive(with: self) { owner, _ in
                if textView.textColor == .black
                    && textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    textView.text = owner.chatWritingSectionView.textViewPlaceHolder
                    textView.textColor = .lightGray
                }
            }
            .disposed(by: disposeBag)
        
        output.chattingSendingValid
            .drive(chatWritingSectionView.sendButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        output.clearSendButtonTrigger
            .drive(with: self) { owner, _ in
                owner.chatWritingSectionView.textView.text = nil
                owner.viewModel.selectedImageDataListRelay.accept([])
            }
            .disposed(by: disposeBag)
        
        output.showPHPickerTrigger
            .drive(with: self) { owner, _ in
                owner.showPHPicker()
            }
            .disposed(by: disposeBag)
        
        output.showImageCountIimitAlertTrigger
            .drive(with: self) { owner, _ in
                owner.makeErrorAlert(title: "이미지 개수 제한", message: "선택할 수 있는 최대 이미지 개수는 5개까지입니다.")
            }
            .disposed(by: disposeBag)
        
        output.selectedImageList
            .drive(with: self) { owner, selectedImageList in
                owner.chatWritingSectionView.collectionView.isHidden = selectedImageList.count <= 0
            }
            .disposed(by: disposeBag)
        
        output.selectedImageList
            .drive(chatWritingSectionView.collectionView.rx.items(cellIdentifier: TextWritingSectionViewCollectionViewCell.identifier, cellType: TextWritingSectionViewCollectionViewCell.self)) { item, element, cell in
                
                if let image = UIImage(data: element) {
                    cell.imageView.image = image
                }
            }
            .disposed(by: disposeBag)
    }
}

extension DirectMessageViewController: PHPickerViewControllerDelegate {
    func showPHPicker() {
        var configuration = PHPickerConfiguration()
        
        configuration.selectionLimit = 5
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
        var imageDataList = [Data]()
        
        var group = DispatchGroup()
        
        for (_, item) in results.enumerated() {
            group.enter()
            let itemProvider = item.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error  in
                    
                    guard let image = image as? UIImage else { return }
                    guard let imageData = image.pngData() else { return }
                    imageDataList.append(imageData)
                    group.leave()
                }
            }
        }
        
        picker.dismiss(animated: true)
        
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            
            var existingImageDataList = viewModel.selectedImageDataListRelay.value
            existingImageDataList = existingImageDataList + imageDataList
            viewModel.selectedImageDataListRelay.accept(existingImageDataList)
        }
    }
}
