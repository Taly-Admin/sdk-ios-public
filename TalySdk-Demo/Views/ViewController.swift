//
//  ViewController.swift
//  DemoApp
//
//  Created by Mehul Goswami on 21/06/23.
//


import UIKit
import TalySdk


class ViewController: UIViewController, BannerViewDelegate {
    func didGetBannerDetail(bannerResponse: [BannerResponse]) {
        debugPrint("BannerView detail = \(bannerResponse)")
    }
    
    func didInfoButtonTap(url: String) {
        let viewController = TalyInfoVC(url: url)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
    
    func didGetError() {
        self.bannerViewHeight.constant = 210
    }
    
    lazy var modalPresenter: ModalPresenter = {
        return ModalPresenter()
    }()
    
    var sdkBannerView: BannerView?
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerLabel: UILabel!
    
    @IBOutlet weak var bannerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var paymentView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textFieldValidationErrorLabel: UILabel!
    @IBOutlet weak var appView: UIView!
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var placeOrderButton: UIButton!
    @IBOutlet weak var duplicateMerchantOrderIdTextField: UITextField!
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    let checkMarkButtton = UIButton()
    
    var userData: UserData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupOtherViews()
        self.setupBannerView()
    }
    
    func setupOtherViews() {
        bannerLabel.text = ""
        amountLabel.text = "Amount"
        textField.placeholder = "Please Enter Amount"
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.black.cgColor
        textField.setLeftPaddingPoints(10)
        textField.addDoneButtonOnKeyboard()
        duplicateMerchantOrderIdTextField.addDoneButtonOnKeyboard()
        placeOrderButton.layer.cornerRadius = 10
        textField.delegate = self
        
        duplicateMerchantOrderIdTextField.placeholder = "Merchant Order Id"
        duplicateMerchantOrderIdTextField.layer.cornerRadius = 5
        duplicateMerchantOrderIdTextField.clipsToBounds = true
        duplicateMerchantOrderIdTextField.layer.borderWidth = 1.0
        duplicateMerchantOrderIdTextField.layer.borderColor = UIColor.black.cgColor
        duplicateMerchantOrderIdTextField.setLeftPaddingPoints(10)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        backgroundView.addGestureRecognizer(tapGestureRecognizer)
        self.setupView()
        
    }
    
    func setupBannerView() {
        sdkBannerView = BannerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 58), userName: userData.userName, password: userData.password, name: "", quantity: 1, amount: "", currency: "KD")
        // sdkBannerView?.isShowCustomView = true
        sdkBannerView?.delegate = self
        self.bannerView.addSubview(sdkBannerView!)
    }
    
    func setupView() {
        // Create the stack view
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.contentMode = .scaleAspectFit
        stackView.spacing = 15
        
        //button.setTitle("Your Button Title", for: .normal)
        checkMarkButtton.setImage(UIImage(named: "checkmark"), for: UIControl.State.normal)
        checkMarkButtton.addTarget(self, action: #selector(checkMarkButtonTapped), for: .touchUpInside)
        stackView.addArrangedSubview(checkMarkButtton)
        checkMarkButtton.translatesAutoresizingMaskIntoConstraints = false
        checkMarkButtton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        let logoImage = UIImageView()
        //button.setTitle("Your Button Title", for: .normal)
        logoImage.image = UIImage(named: "telyLogo1")
        logoImage.contentMode = .scaleAspectFit
        stackView.addArrangedSubview(logoImage)
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        logoImage.widthAnchor.constraint(equalToConstant: 45).isActive = true
        logoImage.heightAnchor.constraint(equalToConstant: 21).isActive = true
        
        // Create the label
        let label = UILabel()
        label.text = "Split payments with Taly"
        label.textColor =  UIColor.textColor
        label.font = UIFont(name: "Manrope-SemiBold", size: 14)
        
        stackView.addArrangedSubview(label)
        
        self.appView.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.allEdgeAnchor(to: self.appView, left: 5, right: 5)
    }
    
    @objc func handleTap() {
        textField.resignFirstResponder()
    }
    
    @objc func infoButtonTapped() {
        
    }
    
    @objc func checkMarkButtonTapped() {
        if textField.text?.isEmpty == true {
            textFieldValidationErrorLabel.text = "Please enter amount"
            //showAlert(title: "Please enter amount")
        } else if self.validateValue(Float(textField.text ?? "0") ?? 0)  == false {
            self.setupDataOnTextFieldValueChanged()
            textFieldValidationErrorLabel.text = "Amount should be greater than 1 and less than 5"
            //   showAlert(title: "Please enter valid amount")
        } else {
            bannerViewHeight.constant = 58
            sdkBannerView?.isHidden = false
            if let value = textField.text {
                sdkBannerView?.amount = "\(value)"
            }
            bannerLabel.text = "Banner View"
            textFieldValidationErrorLabel.text = ""
            checkMarkButtton.setImage(UIImage(named: "checkboxSelected"), for: UIControl.State.normal)
        }
    }
    
    func validateValue(_ value: Float) -> Bool {
        if value <= 0 || value > 5 {
            return false
        } else {
            return true
        }
    }
    
    func setupDataOnTextFieldValueChanged() {
        bannerViewHeight.constant = 0
        bannerLabel.text = ""
        sdkBannerView?.isHidden = true
        textFieldValidationErrorLabel.text = ""
        checkMarkButtton.setImage(UIImage(named: "checkmark"), for: UIControl.State.normal)
    }
    
    @IBAction func onPlaceOrderClicked() {
        
        if textField.text?.isEmpty == true {
            textFieldValidationErrorLabel.text = "Please enter amount"
        } else if self.validateValue(Float(textField.text ?? "0") ?? 0)  == false {
            self.setupDataOnTextFieldValueChanged()
            textFieldValidationErrorLabel.text = "Amount should be greater than 1 and less than 5"
        } else {
            
            let tokenRequest = TokenRequest(username: userData.userName, password: userData.password, grantType: "password", scope: "api")
            
            let psp = PSP(isPspOrder: true, pspProvider: "", subMerchantId: 0, subMerchantName: "")
            let orderItem = OrderItem(sku: "23433312436", type: "Digital", name: "lue shirt 998", itemDescription: "t-shirt made of cotton", quantity: 1, itemPrice: Double(self.textField.text!) ?? 0.00, imageUrl: "https://www.merchantwebsite.com/item1image.jpg", itemUrl: "https://www.merchantwebsite.com/item1.html", itemUnit: "gm", itemSize: "32", itemColor: "white", itemGender: "kids", itemBrand: "Adidas", itemCategory: "Men>Men's Shoes>Running", currency: "KWD")
            
            let customerDetail = CustomerDetails(firstName: "Ahmaa", lastName: "Ali", gender: "Male", phoneNumber: "502223333", customerEmail: "user@example.com", registeredSince: "2023-07-22", loyaltyMember: true, loyaltyLevel: "VIP")
            
            let deliveryAddress = DeliveryAddress(city: "Hawalli", area: "Salmiya", fullAddress: "Hawlli, salmiya, block 5, building 5, floor 2, flat 6", phoneNumber: "502223333", customerEmail: "user@example.com")
            
            
            let merchantId = duplicateMerchantOrderIdTextField.text?.isEmpty == true ? getCurrentTimeInMilliseconds() :  duplicateMerchantOrderIdTextField.text!
            
            let orderRequest = OrderRequest(merchantOrderId: merchantId, language: Locale.current.languageCode ?? "en", subtotal: 1.00, totalAmount: Double(textField.text ?? "0") ?? 0, currency: "KWD", discountAmount: 0.00, taxAmount: 0.000, deliveryAmount: 0.000, deliveryMethod: "home delivery", otherFees: 0.00, psp: psp, orderItems: [orderItem], isDigitalOrder: false, customerDetails: customerDetail, deliveryAddress: deliveryAddress, merchantRedirectURL: "https://yourmerchant.com/checkout/", postBackUrl: "https://yourmerchant.com/yourWebwebhookEndpoint/",
                                            merchantLogo: "https://www.yourmerchant.com/media/merchantLogo.png")
            
            let viewController = PlaceOrderView(orderRequest: orderRequest, tokenRequest: tokenRequest, environment: userData.environment == "Development" ? URLHost.dev : URLHost.production)
            viewController.activityIndicatorColor = .themeColor
            viewController.delegate = self
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.modalPresentationStyle = .fullScreen
            viewController.navigationBarTitleColor = .themeColor
            self.present(navigationController, animated: true)
            self.textField.text = ""
            self.setupDataOnTextFieldValueChanged()
            
        }
    }
    
    func getCurrentTimeInMilliseconds() -> String {
        let currentTime = Date().timeIntervalSince1970 * 1000
        let currentTimeString = String(format: "%.0f", currentTime)
        return currentTimeString
    }
    
    func openSucessFaliurePopup(data: SuccessFailureDetail) {
        let  storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "SuccessFailurePopupVC") as! SuccessFailurePopupVC
        viewController.data = data
        viewController.transitioningDelegate = self
        viewController.modalPresentationStyle = .overFullScreen
        // modalPresenter.height = 180
        self.present(viewController, animated: true)
    }
    
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            self.setupDataOnTextFieldValueChanged()
        } else {
            if textField.text?.isEmpty == true {
                textFieldValidationErrorLabel.text = "Please enter amount"
                //showAlert(title: "Please enter amount")
            } else if self.validateValue(Float(textField.text ?? "0") ?? 0)  == false {
                self.setupDataOnTextFieldValueChanged()
                textFieldValidationErrorLabel.text = "Amount should be greater than 1 and less than 5"
                //   showAlert(title: "Please enter valid amount")
            } else {
                bannerViewHeight.constant = 58
                sdkBannerView?.isHidden = false
                if let value = textField.text {
                    sdkBannerView?.amount = "\(value)"
                }
                bannerLabel.text = "Banner View"
                textFieldValidationErrorLabel.text = ""
                checkMarkButtton.setImage(UIImage(named: "checkboxSelected"), for: UIControl.State.normal)
            }
        }
    }
    
}

extension ViewController: PlaceOrderDelegate {
    func didFinishPlaceOrderWithSuccess(successOrderDetails: OrderDetails) {
        debugPrint(successOrderDetails)
        let data = SuccessFailureDetail(headerTitle: "Success",                              orderId: Int(successOrderDetails.merchantOrderId),
                                        Amount: Int(successOrderDetails.totalAmount ?? 0.000),
                                        date: successOrderDetails.orderDate,
                                        orderDetails: successOrderDetails )
        self.openSucessFaliurePopup(data: data)
    }
    
    func didFinishPlaceOrderWithError(error: OtherErrorResponse) {
        debugPrint(error)
        let data = SuccessFailureDetail(headerTitle: "Error", error: error.message, orderDetails: nil, otherError: error)
        self.openSucessFaliurePopup(data: data)
        
    }
    
    func didFinishPlaceOrderWithFailure(failureOrderDetail: OrderDetails) {
        debugPrint(failureOrderDetail)
        let data = SuccessFailureDetail(headerTitle: "Failure",                              orderId: Int(failureOrderDetail.merchantOrderId),
                                        Amount:
                                            Int(failureOrderDetail.totalAmount ?? 0.000),
                                        date: failureOrderDetail.orderDate, orderDetails: failureOrderDetail )
        
        self.openSucessFaliurePopup(data: data)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard when return key is pressed
        textField.resignFirstResponder()
        return true
    }
}

// MARK:- UIViewControllerTransitioningDelegate
extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        modalPresenter.isPresenting = true
        return modalPresenter
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        modalPresenter.isPresenting = false
        return modalPresenter
    }
}
