//
//  UIViewController+Extension.swift
//  WeatherApp
//
// Created by Arda Sisli on 9.10.2022.
//

import UIKit

extension UIViewController {
    func showAlert(error: String, actionTitle: String) {
        let errorAlert = UIAlertController(title: "Error",
            message: error,
            preferredStyle: .alert
    )
        let errorAction = UIAlertAction(title: actionTitle,
            style: .cancel
    )
        errorAlert.addAction(errorAction)
         self.present(errorAlert, animated: true)
    }
}
