//
//  TabBarViewController.swift
//  SurdurulebilirMahalleler
//
//  Created by MacBook on 23.04.2024.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTabItems()
    }
    
    func addTabItems() {
        
        let homeVC = FeedViewController()
        let vc2 = FeedViewController()
        let vc3 = FeedViewController()
        let vc4 = FeedViewController()
        let vc5 = FeedViewController()
        
        let feed = UINavigationController(rootViewController: homeVC)
        let map = UINavigationController(rootViewController: vc2)
        let points = UINavigationController(rootViewController: vc3)
        let events = UINavigationController(rootViewController: vc4)
        let profile = UINavigationController(rootViewController: vc5)
        
        
        let shadowView = UIView(frame: tabBar.bounds)
        shadowView.backgroundColor = .white
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.1
        shadowView.layer.shadowOffset = CGSize(width: 0, height: -3)
        shadowView.layer.shadowRadius = 3
        
        
        tabBar.insertSubview(shadowView, at: 0)
        
        
        
        feed.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "house"), tag: 0)
        feed.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        map.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "map"), tag: 1)
        map.tabBarItem.selectedImage = UIImage(systemName: "map.fill")
        points.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "list.bullet.clipboard"), tag: 2)
        points.tabBarItem.selectedImage = UIImage(systemName: "list.bullet.clipboard.fill")
        events.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "calendar"), tag: 3)
        events.tabBarItem.selectedImage = UIImage(systemName: "calendar")
        profile.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "person"), tag: 4)
        profile.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        
        setViewControllers([feed,map,points,events,profile], animated: true)
        
        
    }
}
