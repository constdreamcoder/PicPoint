//
//  ProfileViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/15/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class ProfileViewController: BaseViewController {
    
    private let viewModel = ProfileViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
    }

}

extension ProfileViewController {
    @objc func rightBarButtonTapped(_ barButtonItem: UIBarButtonItem) {
        print("설정으로 이동")
        let settingsVC = SettingsViewController()
        navigationController?.pushViewController(settingsVC, animated: true)
    }
}

extension ProfileViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        let rightBarButtonImage = UIImage(systemName: "gearshape")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarButtonImage, style: .plain, target: self, action: #selector(rightBarButtonTapped))
    }
    
    func configureConstraints() {

    }
    
    func configureUI() {
        view.backgroundColor = .green
    }
    
    func bind() {
        let input = ProfileViewModel.Input()
        
        let output = viewModel.transform(input: input)
    }
}
