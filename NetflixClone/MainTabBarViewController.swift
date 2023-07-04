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
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let upcomingVC = UINavigationController(rootViewController: UpcomingViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let downloadsVC = UINavigationController(rootViewController: DownloadsViewController())
        
        
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        upcomingVC.tabBarItem.image = UIImage(systemName: "play.circle")
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        downloadsVC.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        homeVC.title = "Home"
        upcomingVC.title = "Coming soon"
        searchVC.title = "Top Search"
        downloadsVC.title = "Downloads"
        
        
        tabBar.tintColor = .label
        
        
        
        
        setViewControllers([homeVC,upcomingVC,searchVC,downloadsVC], animated: true)
    }


}

