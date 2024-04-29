//
//  FollowPageViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/29/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FollowContentsPageViewController: UIPageViewController {
    
    let followerVC = FollowerViewController()
    let followingVC = FollowingViewController()
    
    lazy var dataViewControllers: [UIViewController] = [followerVC, followingVC]
    
    lazy var currentPage: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= currentPage ? .forward : .reverse
            setViewControllers(
                [dataViewControllers[currentPage]],
                direction: direction,
                animated: true,
                completion: nil
            )
        }
    }
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureConstraints()
        configureUI()
    }
}

extension FollowContentsPageViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        
    }
    
    func configureConstraints() {
        
    }
    
    func configureUI() {
        view.backgroundColor = .white
    }
}
