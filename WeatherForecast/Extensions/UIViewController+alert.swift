//
//  UIViewController+alert.swift
//  WeatherForecast
//
//  Created by Vlad Boguzh on 28.03.2024.
//

import UIKit

extension UIViewController {
    func showAlert(_ message: String, handler: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        present(alertController, animated: true)
    }
}
