//
//  TabBarController.swift
//  Pursuit-Core-iOS-Firebase-Project
//
//  Created by Bienbenido Angeles on 5/14/20.
//  Copyright © 2020 Bienbenido Angeles. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    private var feedVC: FeedViewController = {
        let vc = FeedViewController()
        vc.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "photo"), tag: 0)
        return vc
    }()
    
    private var postVC: ImageUploadViewController = {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ImageUploadViewController") as? ImageUploadViewController else {
            fatalError()
        }
        vc.tabBarItem = UITabBarItem(title: "Post", image: UIImage(systemName: "square.and.pencil"), tag: 1)
        return vc
    }()
    
    private var profileVC: ProfileViewController = {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else {
            fatalError()
        }
        vc.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 2)
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        let controllers = [feedVC, postVC, profileVC]
        viewControllers = controllers.map{UINavigationController(rootViewController: $0)}

    }

}
