//
//  UINavigationController+.swift
//  RunLog
//
//  Created by 신승재 on 3/14/25.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

extension UIViewController {
    private struct LoadingIndicator {
        static var activityIndicator: NVActivityIndicatorView?
    }
    
    /// 로딩 인디케이터 시작
    public func startLoading() {
        print(#function)
        guard LoadingIndicator.activityIndicator == nil else { return } // 이미 있으면 중복 생성 방지
        
        let indicator = NVActivityIndicatorView(
            frame: .zero,
            type: .pacman,
            color: .green, //.LightGreen
            padding: 44
        )
        
        view.addSubview(indicator)
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        indicator.startAnimating()
        LoadingIndicator.activityIndicator = indicator
    }
    
    /// 로딩 인디케이터 종료
    public func stopLoading() {
        print(#function)
        LoadingIndicator.activityIndicator?.stopAnimating()
        LoadingIndicator.activityIndicator?.removeFromSuperview()
        LoadingIndicator.activityIndicator = nil
    }
    
    /// 네비게이션 바의 스타일 설정
    public func setupNavigationBarAppearance(titleFont: UIFont, titleColor: UIColor) {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [
            .foregroundColor: titleColor,
            .font: titleFont
        ]
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
    }
    
    /// 탭 바의 스타일 설정
    public func setupTabBarAppearance(tintColor: UIColor) {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(hex: "#1C1C1C")
        appearance.shadowColor = .clear
        
        self.tabBarController?.tabBar.standardAppearance = appearance
        self.tabBarController?.tabBar.scrollEdgeAppearance = appearance
        self.tabBarController?.tabBar.tintColor = tintColor // .LightGreen
    }
    
    /// 터치하면 키보드가 내려가는 기능 추가
    public func setupTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    public func showAlert(message: String) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
