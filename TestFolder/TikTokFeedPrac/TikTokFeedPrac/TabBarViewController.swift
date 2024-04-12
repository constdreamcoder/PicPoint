//
//  TabBarViewController.swift
//  TikTokFeedPrac
//
//  Created by SUCHAN CHANG on 4/12/24.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tikTokVC = TikTokFeedViewController()
        
        let tikTokNav = UINavigationController(rootViewController: tikTokVC)
        
        tikTokNav.tabBarItem = UITabBarItem(
            title: "검색",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        
        setViewControllers([tikTokNav], animated: false)
    }
    
}
