//
//  LogViewController.swift
//  RunLog
//
//  Created by 신승재 on 3/14/25.
//

import UIKit
import Combine
import SnapKit
import Then

final class LogViewController: UIViewController {
    
    // MARK: - Properties
    private let logView = LogView()
    private let logViewModel = LogViewModel()
    
    private var dataViewControllers: [UIViewController] = []
    private var currentPage: Int = 0
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //navigationController?.setNavigationBarHidden(false, animated: animated)
        logViewModel.send(.viewWillAppear)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Setup UI
    private func setupUI() {
        dataViewControllers.append(
            CalendarViewController(viewModel: logViewModel)
        )
        
        dataViewControllers.append(
            TimelineViewController(viewModel: logViewModel)
        )
        
        view.addSubview(logView)
        logView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        logView.segmentedControl.addTarget(
            self,
            action: #selector(changeValue(control:)),
            for: .valueChanged
        )
        
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
        //title = "LOGO"
    }
    
    // MARK: - Bind ViewModel
    private func bindViewModel() {
        logViewModel.output.navigationEvent
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                
                let detailVM = DetailLogViewModel(date: date)
                let detailVC = DetailLogViewController(viewModel: detailVM)
                detailVC.title = date.formattedString(.monthDay)
                self?.navigationController?.pushViewController(detailVC, animated: true)
            }
            .store(in: &cancellables)
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

// MARK: - PageViewController Delegate
extension LogViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController),
                index - 1 >= 0
        else { return nil }
        return dataViewControllers[index - 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let index = dataViewControllers.firstIndex(of: viewController),
                index + 1 < dataViewControllers.count
        else { return nil }
        return dataViewControllers[index + 1]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let viewController = pageViewController.viewControllers?.first,
              let index = dataViewControllers.firstIndex(of: viewController)
        else { return }
        currentPage = index
        logView.segmentedControl.selectedSegmentIndex = index
    }
}
