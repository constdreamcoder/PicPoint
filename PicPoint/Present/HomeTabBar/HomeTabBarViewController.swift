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
        let profileVC = ProfileViewController()
     
        let homeNav = UINavigationController(rootViewController: homeVC)
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        homeNav.tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        profileNav.tabBarItem = UITabBarItem(
            title: "프로필",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        
        setViewControllers([homeNav, profileNav], animated: false)
    }
}
