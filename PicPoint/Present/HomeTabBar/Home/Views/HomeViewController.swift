//
//  HomeViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/14/24.
//

import UIKit
import SnapKit

final class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureConstraints()
        configureUI()
        bind()
    }
}

extension HomeViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        
    }
    
    func configureConstraints() {
        
    }
    
    func configureUI() {
        
    }
    
    func bind() {
        view.backgroundColor = .brown
    }
}
