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
        let hashTagSearchVC = HashTagSearchViewController()
        let profileVM = ProfileViewModel()
        let profileVC = ProfileViewController(profileViewModel: profileVM)
     
        let homeNav = UINavigationController(rootViewController: homeVC)
        let hashTagSearchNav = UINavigationController(rootViewController: hashTagSearchVC)
        let profileNav = UINavigationController(rootViewController: profileVC)
        
        homeNav.tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill")
        )
        
        hashTagSearchNav.tabBarItem = UITabBarItem(
            title: "검색",
            image: UIImage(systemName: "magnifyingglass"),
            selectedImage: UIImage(systemName: "magnifyingglass")
        )
        
        profileNav.tabBarItem = UITabBarItem(
            title: "프로필",
            image: UIImage(systemName: "person"),
            selectedImage: UIImage(systemName: "person.fill")
        )
        
        tabBar.tintColor = .black
        tabBar.backgroundColor = .white
        
        setViewControllers([homeNav, hashTagSearchNav, profileNav], animated: false)
    }
}
