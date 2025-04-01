//
//  LoginVC.swift
//  PaymentDemoApp
//
//  Created by Taly on 11/07/23.
//

import UIKit

class LoginVC: UIViewController {
    
    // MARK: - variables
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var textFieldValidationErrorLabelMail: UILabel!
    @IBOutlet weak var textFieldValidationErrorLabelPassword: UILabel!
    
    @IBOutlet weak var enviromentView: UIView!
    @IBOutlet weak var devlopmentButton: UIButton!
    @IBOutlet weak var productionButton: UIButton!
    
    // MARK: - view methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setScreen()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: set screen and data
    func setScreen(){

        let allTextField = self.view.getTextfield(view: self.view)
        for txtField in allTextField
        {
            txtField.setLeftPaddingPoints(10)
       //     txtField.addDoneButtonOnKeyboard()
            txtField.delegate = self
        }
        
        showPasswordButton.addTarget(self, action: #selector(showPasswordButtonTapped), for: .touchUpInside)
        
        devlopmentButton.backgroundColor = UIColor.init(named: "appTheme")
        devlopmentButton.setTitleColor(UIColor.white, for: .normal)
        productionButton.setTitleColor(UIColor.black, for: .normal)
        
        mailTextField.text = User.userName == "" ? "DemoMerchant#153": User.userName
        passwordTextField.text = User.password == "" ? "Dem@Merch@nt#2023": User.password
    }
    
    // MARK: user interaction
    @IBAction func loginBtnAction(_ sender: UIButton) {
        if mailTextField.text?.isEmpty == true {
            textFieldValidationErrorLabelMail.text = ErrorMsg.userNameRequired.rawValue
        } else if passwordTextField.text?.isEmpty == true {
            textFieldValidationErrorLabelMail.text = ""
            textFieldValidationErrorLabelPassword.text = ErrorMsg.PasswordRequired.rawValue
        } else {
            textFieldValidationErrorLabelMail.text = ""
            textFieldValidationErrorLabelPassword.text = ""
            User.userName = mailTextField.text! 
            User.password = passwordTextField.text!
            self.navigateToNextScreen()
        }
    }
    
    @objc private func showPasswordButtonTapped() {
        passwordTextField.isSecureTextEntry.toggle()
        showPasswordButton.isSelected = !passwordTextField.isSecureTextEntry
    }
    
    @IBAction func environmentBtnAction(_ sender: UIButton) {
        if sender == devlopmentButton {
            appEnvironment = .dev
            productionButton.backgroundColor = UIColor.white
            productionButton.setTitleColor(UIColor.black, for: .normal)
        } else {
            appEnvironment = .prd
            devlopmentButton.backgroundColor = UIColor.white
            devlopmentButton.setTitleColor(UIColor.black, for: .normal)
        }
        
        sender.backgroundColor = UIColor.init(named: "appTheme")
        sender.setTitleColor(UIColor.white, for: .normal)
    }
    
    func navigateToNextScreen(){
        if let viewController = storyboard?.instantiateViewController(identifier: "PlaceOrderVC") as? PlaceOrderVC {
            viewController.userData = UserData(userName: mailTextField.text!, password: passwordTextField.text!, environment: appEnvironment.rawValue)
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

// MARK: - delegates
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
}
