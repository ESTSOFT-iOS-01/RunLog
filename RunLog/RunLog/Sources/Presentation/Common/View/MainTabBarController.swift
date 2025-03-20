//
//  MainTabBarController.swift
//  RunLog
//
//  Created by 심근웅 on 3/14/25.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    let dataContainer = CoreDataContainer()
    let appConfigRepository : AppConfigRepositoryImpl!
//    let dayLogRepository : DayLogRepositoryImpl!
    
    // MARK: - Init
    init(appConfigRepository : AppConfigRepositoryImpl, dayLogRepository: DayLogRepositoryImpl) {
        self.appConfigRepository = AppConfigRepositoryImpl(context: dataContainer.context)
//        self.dayLogRepository = DayLogRepositoryImpl(context: dataContainer.context)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        
        let runView = UINavigationController(rootViewController: RunHomeViewController())
        runView.title = "Run"
        runView.tabBarItem = UITabBarItem(
            title: "Run",
            image: UIImage(systemName: "star"),
            selectedImage: UIImage(systemName: "star.fill")
        )
        
        let logView = UINavigationController(
            rootViewController: LogViewController()
        )
        logView.view.backgroundColor = .blue
        logView.title = "Log"
        logView.tabBarItem = UITabBarItem(
            title: "Log",
            image: UIImage(systemName: "star"),
            selectedImage: UIImage(systemName: "star.fill")
        )
        
        
        let usecase = AppConfigUsecaseImpl(appConfigRepository: self.appConfigRepository)
        let settingVM = MyPageViewModel(appConfigUseCase: usecase)
        let settingVC = MyPageViewController(viewModel: settingVM)
        
        let settingView = UINavigationController(rootViewController: settingVC)
        settingView.title = "Setting"
        settingView.tabBarItem = UITabBarItem(
            title: "Setting",
            image: UIImage(systemName: "star"),
            selectedImage: UIImage(systemName: "star.fill")
        )
        
        self.viewControllers = [runView, logView, settingView]
    }
}
