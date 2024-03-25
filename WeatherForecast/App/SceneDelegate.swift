//
//  SceneDelegate.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 25.03.2024.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)

        let tabBarController = UITabBarController()

        let weatherViewModel = WeatherViewModel()
        let weatherVC = WeatherViewController(viewModel: weatherViewModel)
        weatherVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), tag: 0)

        let searchViewModel = SearchViewModel()
        let searchVC = SearchViewController(viewModel: searchViewModel)
        searchVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "magnifyingglass"), tag: 1)

        tabBarController.viewControllers = [
            weatherVC,
            searchVC
        ]

        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        tabBarController.tabBar.standardAppearance = tabBarAppearance
        tabBarController.tabBar.scrollEdgeAppearance = tabBarAppearance

        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}
