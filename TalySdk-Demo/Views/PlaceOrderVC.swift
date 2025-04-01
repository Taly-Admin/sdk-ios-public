//
//  ViewController.swift
//  DemoApp
//
//  Created by Taly on 21/06/23.
//


import UIKit
import TalySdk


class PlaceOrderVC: UIViewController {
    
    // MARK: - variables
    lazy var modalPresenter: ModalPresenter = {
        return ModalPresenter()
    }()
    
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var lblAmtError: UILabel!
    
    @IBOutlet weak var vwBannerOuter: UIView!
    @IBOutlet weak var bannerView: UIView!
    @IBOutlet weak var bannerViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var vwPaymentOpt: UIView!
    @IBOutlet weak var checkMarkButtton: UIButton!
    
    @IBOutlet weak var txtMerchantOrderId: UITextField!
    
    @IBOutlet weak var placeOrderButton: UIButton!
    
    var sdkBannerView: BannerView?
    var userData: UserData!
    
    // MARK: - view methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpScreen()
        self.setupBannerView()
    }
    
    // MARK: set screen
    func setUpScreen() {
        // set style to textfileds
        let allTextField = self.view.getTextfield(view: self.view)
        for txtField in allTextField
        {
            txtField.setLeftPaddingPoints(10)
            txtField.addDoneButtonOnKeyboard()
            txtField.delegate = self
        }
        self.changePlaceOrderButtonState()
        // handle tap gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupBannerView() {
        sdkBannerView = BannerView(frame: CGRect(x: 0, y: 0, width: self.bannerView.bounds.width, height: 58), userName: userData.userName, password: userData.password, name: "", quantity: 1, amount: "", currency: "KD")
        // sdkBannerView?.isShowCustomView = true
        sdkBannerView?.delegate = self
        self.bannerView.addSubview(sdkBannerView!)
    }
    
    func validateValue(_ value: String) -> Bool {
        let numberStr: String = value
        let formatter: NumberFormatter = NumberFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en") as Locale?
        let final = formatter.number(from: numberStr) ?? 0
        let doubleNumber = Float(truncating: final)
//        debugPrint("fomatted number: \(doubleNumber)")
        let validateNum = doubleNumber <= 0 ? false : true
        return validateNum
    }
    
    func setupDataOnTextFieldValueChanged() {
        vwBannerOuter?.isHidden = true
        vwPaymentOpt?.isHidden = true
        lblAmtError.text = ""
        checkMarkButtton.isSelected = false
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
        self.present(viewController, animated: true, completion: {
            self.txtAmount.text = ""
            self.setupDataOnTextFieldValueChanged()
            self.changePlaceOrderButtonState()
        })
    }
    
    func validateData(enteredAmt: String){
        if enteredAmt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            self.setupDataOnTextFieldValueChanged()
            lblAmtError.text = ErrorMsg.amtRequired.rawValue
            changePlaceOrderButtonState()
        } else if self.validateValue(txtAmount.text ?? "0") == false {
            self.setupDataOnTextFieldValueChanged()
            lblAmtError.text = ErrorMsg.amtValidation.rawValue
            changePlaceOrderButtonState()
        } else {
            vwBannerOuter?.isHidden = false
      //      bannerViewHeight.constant = 58
            vwPaymentOpt?.isHidden = false
            sdkBannerView?.amount = txtAmount.text ?? ""
            lblAmtError.text = ""
            checkMarkButtton.isSelected = true
            changePlaceOrderButtonState(isEnble: true)
        }
    }
    
    func changePlaceOrderButtonState(isEnble: Bool = false){
        placeOrderButton.isUserInteractionEnabled = isEnble
        placeOrderButton.backgroundColor = isEnble ? UIColor.init(named: "appTheme") : UIColor(named: "appTheme")?.withAlphaComponent(0.5)
    }
    
    // MARK: User interaction
    @IBAction func checkMarkButtonTapped() {
        validateData(enteredAmt: txtAmount.text ?? "")
    }
    
    @IBAction func onPlaceOrderClicked() {
        let tokenRequest = TokenRequest(username: userData.userName, password: userData.password, grantType: "password", scope: "api")
        
        let psp = PSP(isPspOrder: true, pspProvider: "", subMerchantId: 0, subMerchantName: "")
        let orderItem = OrderItem(sku: "23433312436", type: "Digital", name: "lue shirt 998", itemDescription: "t-shirt made of cotton", nameArabic: "lue shirt 998", itemDescriptionArabic: "t-shirt made of cotton", quantity: 1, itemPrice: Double(self.txtAmount.text ?? "") ?? 0.00, imageUrl: "https://www.merchantwebsite.com/item1image.jpg", itemUrl: "https://www.merchantwebsite.com/item1.html", itemUnit: "gm", itemSize: "32", itemColor: "white", itemGender: "kids", itemBrand: "Adidas", itemCategory: "Men>Men's Shoes>Running", currency: "KWD")
        
        let customerDetail = CustomerDetails(firstName: "Ahmaa", lastName: "Ali", gender: "Male", phoneNumber: "502223333", customerEmail: "user@example.com", registeredSince: "2023-07-22", loyaltyMember: true, loyaltyLevel: "VIP")
        
        let deliveryAddress = DeliveryAddress(city: "Hawalli", area: "Salmiya", fullAddress: "Hawlli, salmiya, block 5, building 5, floor 2, flat 6", phoneNumber: "502223333", customerEmail: "user@example.com")
        
        
        let merchantId = txtMerchantOrderId.text?.isEmpty == true ? getCurrentTimeInMilliseconds() : txtMerchantOrderId.text!
        
        let orderRequest = OrderRequest(merchantOrderId: merchantId, language: Locale.current.languageCode ?? "en", subtotal: 1.00, totalAmount: Double(txtAmount.text ?? "0") ?? 0, currency: "KWD", discountAmount: 0.00, taxAmount: 0.000, deliveryAmount: 0.000, deliveryMethod: "home delivery", otherFees: 0.00, psp: psp, orderItems: [orderItem], isDigitalOrder: false, customerDetails: customerDetail, deliveryAddress: deliveryAddress, merchantRedirectURL: "https://yourmerchant.com/checkout/", postBackUrl: "https://yourmerchant.com/yourWebwebhookEndpoint/",
                                        merchantLogo: "https://www.yourmerchant.com/media/merchantLogo.png")
        
        openSDKPlaceOrderScreen(request: orderRequest, token: tokenRequest)
    }
    
    func openSDKPlaceOrderScreen(request: OrderRequest, token: TokenRequest){
        let viewController = PlaceOrderView(orderRequest: request, tokenRequest: token, environment: userData.environment == appEnv.dev.rawValue ? URLHost.dev : URLHost.production)
        viewController.activityIndicatorColor = .themeColor
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        viewController.navigationBarTitleColor = .themeColor
        self.present(navigationController, animated: true)
    }
    
    @objc func handleTap() {
        txtAmount.resignFirstResponder()
    }
}

// MARK: - Delegate methods
extension PlaceOrderVC: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard textField == txtAmount else { return}
        validateData(enteredAmt: textField.text ?? "")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension PlaceOrderVC: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        modalPresenter.isPresenting = true
        return modalPresenter
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        modalPresenter.isPresenting = false
        return modalPresenter
    }
}

extension PlaceOrderVC: PlaceOrderDelegate {
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
}

extension PlaceOrderVC: BannerViewDelegate{
    func didGetBannerDetail(bannerResponse: [BannerResponse]) {
        debugPrint("BannerView detail = \(bannerResponse)")
        DispatchQueue.main.async(execute: {
            self.bannerViewHeight.constant = 58
        })
    }
    
    func didInfoButtonTap(url: String) {
        let viewController = TalyInfoVC(url: url)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
    
    func didGetError() {
        DispatchQueue.main.async(execute: {
            self.bannerViewHeight.constant = 210
        })
    }
}
