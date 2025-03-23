//
//  MainTabBarController.swift
//  RunLog
//
//  Created by 심근웅 on 3/14/25.
//

import UIKit

enum MainTab: CaseIterable {
    case run
    case log
    case myPage
    
    var title: String {
        switch self {
        case .run: return "러닝"
        case .log: return "기록"
        case .myPage: return "마이"
        }
    }
    
    var icon: RLIcon {
        switch self {
        case .run: return .run
        case .log: return .log
        case .myPage: return .myPage
        }
    }
    
    var viewController: UIViewController {
        switch self {
        case .run:
            return RunHomeViewController()
        case .log:
            return LogViewController()
        case .myPage:
            return MyPageViewController(viewModel: MyPageViewModel())
        }
    }
    
    func navigationController() -> UINavigationController {
        let nav = UINavigationController(rootViewController: viewController)
        nav.tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(systemName: icon.name),
            selectedImage: UIImage(systemName: icon.name)
        )
        return nav
    }
}

class MainTabBarController: UITabBarController {
    
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = MainTab.allCases.map { $0.navigationController() }
    }
}
