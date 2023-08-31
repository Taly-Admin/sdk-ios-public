//
//  LoginVC.swift
//  PaymentDemoApp
//
//  Created by Mehul Goswami on 11/07/23.
//

import UIKit

class LoginVC: UIViewController {
    
    var activeField: UITextField!
    
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var textFieldValidationErrorLabelMail: UILabel!
    @IBOutlet weak var textFieldValidationErrorLabelPassword: UILabel!
    var environment: String = "Development"
    
    @IBOutlet weak var enviromentView: UIView!
    @IBOutlet weak var devlopmentButton: UIButton!
    @IBOutlet weak var productionButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        showPasswordButton.contentMode = .scaleAspectFit
        if #available(iOS 13.0, *) {
            showPasswordButton.setImage(UIImage(systemName: "eye"), for: .normal)
        } else {
            // Fallback on earlier versions
        }
        
        showPasswordButton.addTarget(self, action: #selector(showPasswordButtonTapped), for: .touchUpInside)
        showPasswordButton.tintColor = .gray
        
        signInBtn.layer.cornerRadius = 10
        
        mailTextField.delegate = self
        passwordTextField.delegate = self
        
        passwordTextField.layer.cornerRadius = 5
        passwordTextField.clipsToBounds = true
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderColor = UIColor.black.cgColor
        passwordTextField.setLeftPaddingPoints(10)
        
        mailTextField.layer.cornerRadius = 5
        mailTextField.clipsToBounds = true
        mailTextField.layer.borderWidth = 1.0
        mailTextField.layer.borderColor = UIColor.black.cgColor
        mailTextField.setLeftPaddingPoints(10)
        
        enviromentView.layer.cornerRadius = 5
        enviromentView.clipsToBounds = true
        enviromentView.layer.borderWidth = 1.0
        enviromentView.layer.borderColor = UIColor.black.cgColor
        
        devlopmentButton.backgroundColor = UIColor.hexStringToUIColor(hex: "#233756")
        devlopmentButton.setTitleColor(UIColor.white, for: .normal)
        productionButton.setTitleColor(UIColor.black, for: .normal)
        
        #if DEBUG
        mailTextField.text = ""//YOUR_USER_NAME"
        passwordTextField.text = ""//YOUR_PASSWORD"
        #endif
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc private func showPasswordButtonTapped() {
        passwordTextField.isSecureTextEntry.toggle()
        let imageName = passwordTextField.isSecureTextEntry ? "eye" : "eye.slash"
        if #available(iOS 13.0, *) {
            showPasswordButton.setImage(UIImage(systemName: imageName), for: .normal)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func loginBtnAction(_ sender: UIButton) {
        if mailTextField.text?.isEmpty == true {
            textFieldValidationErrorLabelMail.text = "Please enter email"
        } else if passwordTextField.text?.isEmpty == true {
            textFieldValidationErrorLabelMail.text = ""
            textFieldValidationErrorLabelPassword.text = "Please enter Password"
        } else {
            textFieldValidationErrorLabelMail.text = ""
            textFieldValidationErrorLabelPassword.text = ""
            if let viewController = storyboard?.instantiateViewController(identifier: "ViewController") as? ViewController {
                viewController.userData = UserData(userName: mailTextField.text!, password: passwordTextField.text!, environment: self.environment)
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func environmentBtnAction(_ sender: UIButton) {
        if sender.titleLabel?.text == "Development" {
            environment = "Development"
            productionButton.backgroundColor = UIColor.white
            productionButton.setTitleColor(UIColor.black, for: .normal)
        } else if sender.titleLabel?.text == "Production" {
            environment = "Production"
            devlopmentButton.backgroundColor = UIColor.white
            devlopmentButton.setTitleColor(UIColor.black, for: .normal)
        }
        
        sender.backgroundColor = UIColor.hexStringToUIColor(hex: "#233756")
        sender.setTitleColor(UIColor.white, for: .normal)
    }
    
}

extension LoginVC: UITextFieldDelegate {
    // text field Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTage=textField.tag+1;
        let nextResponder=textField.superview?.viewWithTag(nextTage) as UIResponder?
        if (nextResponder != nil){
            nextResponder?.becomeFirstResponder()
        }
        else{
            textField.resignFirstResponder()
        }
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }
    
}

struct UserData {
    var userName: String
    var password: String
    var environment: String
    
    init(userName: String, password: String, environment: String) {
        self.userName = userName
        self.password = password
        self.environment = environment
    }
}
