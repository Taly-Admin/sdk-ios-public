//
//  SuccessFailurePopupVC.swift
//  PaymentDemoApp
//
//  Created by Mehul Goswami on 21/06/23.
//
import UIKit
import TalySdk

class SuccessFailurePopupVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var jsonValueTextView: UITextView!
    
    var data: SuccessFailureDetail?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setTitleAndImage()
    }
    
    @IBAction func closeAction() {
        self.dismissView()
        
    }
    
    func setTitleAndImage() {
        
        if let value = data {
            self.titleLabel.text = value.headerTitle
            if let orderDetail = value.orderDetails {
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                
                do {
                    let jsonData = try encoder.encode(orderDetail)
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        debugPrint(jsonString)
                        // self.orderIdLabel.text = jsonString.replacingOccurrences(of: ",", with: ",\n")
                        self.jsonValueTextView.text = jsonString.replacingOccurrences(of: ",", with: ",\n")
                    }
                } catch {
                    debugPrint("Error: \(error.localizedDescription)")
                }
            } else {
                
                let encoder = JSONEncoder()
                encoder.outputFormatting = .prettyPrinted
                
                do {
                    let jsonData = try encoder.encode(value.otherError!)
                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                        debugPrint(jsonString)
                        //   self.orderIdLabel.text = jsonString.replacingOccurrences(of: ",", with: ",\n")
                        self.jsonValueTextView.text = jsonString.replacingOccurrences(of: ",", with: ",\n")
                        self.jsonValueTextView.textAlignment = .left
                        //  self.orderIdLabel.text = jsonString
                        
                        
                    }
                } catch {
                    debugPrint("Error: \(error.localizedDescription)")
                }
            }
        }
        
    }
    
    func dismissView()  {
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        debugPrint("Deinit called from SuccessFailurePopupVC")
    }
}


struct SuccessFailureDetail {
    var headerTitle: String?
    var orderId: Int?
    var Amount: Int?
    var date: String?
    var error: String?
    var orderDetails: OrderDetails?
    var otherError: OtherErrorResponse?
    
    init(headerTitle: String? = nil, orderId: Int? = nil, Amount: Int? = nil, date: String? = nil, error: String? = nil, orderDetails: OrderDetails?, otherError: OtherErrorResponse? = nil) {
        self.headerTitle = headerTitle
        self.orderId = orderId
        self.Amount = Amount
        self.date = date
        self.error = error
        self.orderDetails = orderDetails
        self.otherError = otherError
        
    }
}
