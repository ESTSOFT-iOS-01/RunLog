//
//  LogViewController.swift
//  RunLog
//
//  Created by 신승재 on 3/14/25.
//

import UIKit
import SnapKit
import Then

final class LogViewController: UIViewController {
    
    // MARK: - Properties
    private let logView = LogView()
    private let vc1 = UIViewController().then { $0.view.backgroundColor = .red }
    private let vc2 = UIViewController().then { $0.view.backgroundColor = .blue }
    
    private lazy var dataViewControllers: [UIViewController] = [vc1, vc2]
    private var currentPage: Int = 0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupActions()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.addSubview(logView)
        logView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        logView.pageViewController.setViewControllers(
            [dataViewControllers[0]],
            direction: .forward,
            animated: true
        )
        logView.pageViewController.delegate = self
        logView.pageViewController.dataSource = self
    }

    // MARK: - Setup Navigation Bar
    private func setupNavigationBar() {
        title = "LOGO"
    }

    private func setupActions() {
        logView.segmentedControl.addTarget(
            self,
            action: #selector(changeValue(control:)),
            for: .valueChanged
        )
    }
}

extension LogViewController {
    // MARK: - Private Fucntions
    @objc private func changeValue(control: UISegmentedControl) {
        let newIndex = control.selectedSegmentIndex
        let direction: UIPageViewController.NavigationDirection = newIndex > currentPage ? .forward : .reverse
        
        logView.pageViewController.setViewControllers(
            [dataViewControllers[newIndex]],
            direction: direction,
            animated: true,
            completion: nil
        )
        currentPage = newIndex
    }
}

// MARK: - PageViewController Delegate & DataSource
extension LogViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
        return dataViewControllers[index - 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController), index + 1 < dataViewControllers.count else { return nil }
        return dataViewControllers[index + 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let viewController = pageViewController.viewControllers?.first,
              let index = dataViewControllers.firstIndex(of: viewController) else { return }
        currentPage = index
        logView.segmentedControl.selectedSegmentIndex = index
    }
}
