//
//  BottomNavbarViewController.swift
//  recipe_ios
//
//  Created by Muhammad Hafiz Mohd Azahar on 18/04/2025.
//

import UIKit

class BottomNavbarViewController: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    

    private func setupTabs() {
        let homeVC = HomePageViewController()
        let profileVC = ProfileViewController()

        homeVC.tabBarItem = UITabBarItem(title: "Home",
                                         image: UIImage(systemName: "house"),
                                         selectedImage: UIImage(systemName: "house.fill"))

        profileVC.tabBarItem = UITabBarItem(title: "Profile",
                                            image: UIImage(systemName: "person"),
                                            selectedImage: UIImage(systemName: "person.fill"))

        let homeNav = UINavigationController(rootViewController: homeVC)
        let profileNav = UINavigationController(rootViewController: profileVC)

        viewControllers = [homeNav, profileNav]
        tabBar.tintColor = .blue
    }
}

