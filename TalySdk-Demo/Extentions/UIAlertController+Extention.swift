//
//  File.swift
//  PaymentDemoApp
//
//  Created by Mehul Goswami on 21/06/23.
//

import UIKit

extension UIAlertController {
    
    func addAction(title: String?, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertAction = UIAlertAction(title: title, style: style, handler: handler)
        self.addAction(alertAction)
    }
    
    class func alert(title: String?, message: String? = nil, style: UIAlertController.Style = .alert, action: UIAlertAction? = nil, cancelAction: UIAlertAction? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        
        if let cancel = cancelAction {
            alertController.addAction(cancel)
        } else {
            alertController.addAction(title: "OK", style: .cancel)
        }
        
        if let actionUnwrapped = action {
            alertController.addAction(actionUnwrapped)
        }
        
        return alertController
    }
    
}


