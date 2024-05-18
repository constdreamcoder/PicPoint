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
        
    }
    
    func configureUI() {
        
    }
    
    func bind() {
        let input = MyChatRoomsViewModel.Input()
        
        let output = viewModel.transform(input: input)
    }
    
}
