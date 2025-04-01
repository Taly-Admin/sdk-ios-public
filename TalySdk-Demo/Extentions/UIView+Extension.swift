//
//  UIView+Extension.swift
//  TalySdk-Demo
//
//  Created by Taly on 26/03/25.
//

import Foundation
import UIKit

extension UIView {
   /// To set corner radius to view
   @IBInspectable var cornerRadiusView: Double {
       get {
           return Double(self.layer.cornerRadius)
       }set {
           self.layer.cornerRadius = CGFloat(newValue)
       }
   }
   
   /// To set border width to view
   @IBInspectable var borderWidth: Double {
       get {
           return Double(self.layer.borderWidth)
       }
       set {
           self.layer.borderWidth = CGFloat(newValue)
       }
   }
   
   /// To set border color to view
   @IBInspectable var borderColor: UIColor? {
       get {
           return UIColor(cgColor: self.layer.borderColor!)
       }
       set {
           self.layer.borderColor = newValue?.cgColor
       }
   }
   
   /// To set shadow color to view
   @IBInspectable var shadowColor: UIColor? {
       get {
           return UIColor(cgColor: self.layer.shadowColor!)
       }
       set {
           self.layer.shadowColor = newValue?.cgColor
       }
   }
   
   /// To set shadow opacity to view
   @IBInspectable var shadowOpacity: Float {
       get {
           return self.layer.shadowOpacity
       }
       set {
           self.layer.shadowOpacity = newValue
       }
   }
   
   /// To set shadow offset to view
   @IBInspectable var shadowOffset: CGPoint {
       set {
           layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
       }
       get {
           return CGPoint(x: layer.shadowOffset.width, y:layer.shadowOffset.height)
       }
   }
   
   /// To set shadow radius to view
   @IBInspectable var shadowRadius: CGFloat {
           get {
               return layer.shadowRadius
           }
           set {
               layer.masksToBounds = false
               layer.shadowRadius = newValue
           }
       }
   
}

extension UIView {
    func getTextfield(view: UIView) -> [UITextField] {
        var results = [UITextField]()
        for subview in view.subviews as [UIView] {
            if let textField = subview as? UITextField {
                results += [textField]
            } else {
                results += getTextfield(view: subview)
            }
        }
        return results
    }
}
