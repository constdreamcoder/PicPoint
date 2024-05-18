//
//  MyChatRoomsViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 5/18/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class MyChatRoomsViewController: BaseViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        
        tableView.register(MyChatRoomsTableViewCell.self, forCellReuseIdentifier: MyChatRoomsTableViewCell.identifier)
        
        return tableView
    }()
    
    private let viewModel: MyChatRoomsViewModel
    
    init(myChatRoomsViewModel: MyChatRoomsViewModel) {
        self.viewModel = myChatRoomsViewModel
        
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

extension MyChatRoomsViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        navigationItem.title = "내 채팅 목록"
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
        let input = MyChatRoomsViewModel.Input()
        
        let output = viewModel.transform(input: input)
        
        output.myChatRoomList
            .drive(tableView.rx.items(cellIdentifier: MyChatRoomsTableViewCell.identifier, cellType: MyChatRoomsTableViewCell.self)) { row, element, cell in
                
                let opponent = element.participants.filter { $0.userId != UserDefaultsManager.userId }[0]
                if let profileImage = opponent.profileImage, !profileImage.isEmpty {
                    let url = URL(string: APIKeys.baseURL + "/\(profileImage)")
                    let placeholderImage = UIImage(systemName: "person.circle")
                    cell.userImageView.kf.setImageWithAuthHeaders(with: url, placeholder: placeholderImage)
                }
                
                cell.userNicknameLabel.text = element.participants.map { $0.nick }.joined(separator: ",")
                guard let lastChat = element.lastChat else { return }
                cell.lastContentLabel.text = lastChat.content
                cell.datelabel.text = lastChat.createdAt.getLastChatDateString
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(Room.self)
            .bind(with: self) { owner, selectedRoom in
                let directMessageVM = DirectMessageViewModel(selectedRoom)
                let directMessageVC = DirectMessageViewController(directMessageViewModel: directMessageVM)
                owner.navigationController?.pushViewController(directMessageVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
}
