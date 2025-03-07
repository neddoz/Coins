//
//  UIViewController+Extension.swift
//  Coins
//
//  Created by kayeli dennis on 03/03/2025.
//
import UIKit

extension UIViewController {
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }
}
