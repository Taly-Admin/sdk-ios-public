//
//  File.swift
//  PaymentDemoApp
//
//  Created by Mehul Goswami on 21/06/23.
//

import UIKit

extension UIViewController {
    
    internal func presentAlert(_ alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String, message: String? = "") {
        let alert = UIAlertController.alert(title: title, message: message)
        presentAlert(alert)
    }
}
