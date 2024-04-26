//
//  ContentsPageViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/26/24.
//

import UIKit
import SnapKit

final class ContentsPageViewController: UIPageViewController {
    
    var myPostVC = MyPostViewController()
    
    let MyLikeVC = MyLikeViewController()
    
    var currentPage: Int = 0 {
        didSet {
            let direction: UIPageViewController.NavigationDirection = oldValue <= currentPage ? .forward : .reverse
            setViewControllers(
                [dataViewControllers[currentPage]],
                direction: direction,
                animated: false,
                completion: nil
            )
        }
    }
    
    var dataViewControllers: [UIViewController] = []
        
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
        configureOtherSettings()
    }
}

extension ContentsPageViewController: UIViewControllerConfiguration {
    func configureNavigationBar() {
        
    }
    
    func configureConstraints() {
        
    }
    
    func configureUI() {
        view.backgroundColor = .white
        setViewControllers([myPostVC], direction: .forward, animated: false)
    }
    
    func configureOtherSettings() {
        dataViewControllers = [myPostVC, MyLikeVC]
    }
}
