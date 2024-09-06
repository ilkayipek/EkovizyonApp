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
        
        let homeVc = FeedViewController()
        let pointsVc = ScoresViewController()
        let eventsVc = EventsViewController()
        let profileVc = CurrentUserProfileViewController()
        
        
        let shadowView = UIView(frame: tabBar.bounds)
        shadowView.backgroundColor = .white
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.1
        shadowView.layer.shadowOffset = CGSize(width: 0, height: -3)
        shadowView.layer.shadowRadius = 3
        
        tabBar.insertSubview(shadowView, at: 0)
        
        
        homeVc.tabBarItem = UITabBarItem(title: "Ana sayfa", image: UIImage(systemName: "house"), tag: 0)
        homeVc.tabBarItem.selectedImage = UIImage(systemName: "house.fill")
        pointsVc.tabBarItem = UITabBarItem(title: "Skor", image: UIImage(systemName: "list.bullet.clipboard"), tag: 1)
        pointsVc.tabBarItem.selectedImage = UIImage(systemName: "list.bullet.clipboard.fill")
        eventsVc.tabBarItem = UITabBarItem(title: "Etkinlikler", image: UIImage(systemName: "calendar"), tag: 2)
        eventsVc.tabBarItem.selectedImage = UIImage(systemName: "calendar")
        profileVc.tabBarItem = UITabBarItem(title: "Profil", image: UIImage(systemName: "person"), tag: 3)
        profileVc.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        
        setViewControllers([homeVc,pointsVc,eventsVc,profileVc], animated: true)
        
    }
}
