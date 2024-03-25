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
        window?.rootViewController = WeatherViewController()
        window?.makeKeyAndVisible()
    }
}
