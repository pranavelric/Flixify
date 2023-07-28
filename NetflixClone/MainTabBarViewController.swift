//
//  ViewController.swift
//  NetflixClone
//
//  Created by Pranav Choudhary on 04/07/23.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()

    }


     private func setupTabBar() {
         let homeVC = createNavigationController(rootViewController: HomeViewController(), title: "Home", imageName: "house")
         let upcomingVC = createNavigationController(rootViewController: UpcomingViewController(), title: "Coming soon", imageName: "play.circle")
         let searchVC = createNavigationController(rootViewController: SearchViewController(), title: "Top Search", imageName: "magnifyingglass")
         let downloadsVC = createNavigationController(rootViewController: DownloadsViewController(), title: "Downloads", imageName: "arrow.down.to.line")
         
         setViewControllers([homeVC, upcomingVC, searchVC, downloadsVC], animated: true)
         tabBar.tintColor = .label
     }
     
     private func createNavigationController(rootViewController: UIViewController, title: String, imageName: String) -> UINavigationController {
         rootViewController.title = title
         rootViewController.tabBarItem.image = UIImage(systemName: imageName)
         let navigationController = UINavigationController(rootViewController: rootViewController)
         return navigationController
     }

}

