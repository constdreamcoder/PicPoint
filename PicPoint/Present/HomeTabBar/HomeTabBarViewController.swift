//
//  HomeTabBarViewController.swift
//  PicPoint
//
//  Created by SUCHAN CHANG on 4/14/24.
//

import UIKit

final class HomeTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = HomeViewController()
     
        let homeNav = UINavigationController(rootViewController: homeVC)
        
        homeNav.tabBarItem = UITabBarItem(
            title: "검색",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        
        setViewControllers([homeNav], animated: false)
    }
}
