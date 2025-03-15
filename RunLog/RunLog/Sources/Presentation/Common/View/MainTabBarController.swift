//
//  MainTabBarController.swift
//  RunLog
//
//  Created by 심근웅 on 3/14/25.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        let runView = UINavigationController(rootViewController: RunHomeViewController())
        runView.title = "Run"
        runView.tabBarItem = UITabBarItem(title: "Run", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        
        let logView = UINavigationController(rootViewController: UIViewController())
        logView.view.backgroundColor = .blue
        logView.title = "Log"
        logView.tabBarItem = UITabBarItem(title: "Log", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        
        let settingView = UINavigationController(rootViewController: UIViewController())
        settingView.view.backgroundColor = .red
        settingView.title = "Setting"
        settingView.tabBarItem = UITabBarItem(title: "Setting", image: UIImage(systemName: "star"), selectedImage: UIImage(systemName: "star.fill"))
        
        self.viewControllers = [runView, logView, settingView]
    }
}
