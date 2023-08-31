# Taly SDK

Taly is a Buy Now, Pay Later provider that allows you to split your payments into four interest-free installments or pay later in 30 days, making your purchases more affordable and convenient.


## Usage

The example app serves as a simple online shopping application that highlights the integration of the Taly SDK for payment processing. The workflow is as follows:

1. **Initialize**: Start by initializing the necessary components within the app.
2. **Create Order**: Within the app, you can initiate the order creation process.
3. **Check Payment Status**: Retrieve and display the payment status after the transaction.


# Quick Start Guide

## 1. How to integrate .xcframework in your project

###Step 1: Drag & drop .xcframework manually into your project's target
###Step 2: Embed & sign .xcframework in your project's target


## 2. Initialize io.taly
Import TalySdk into viewController, and initialize TalySdk with

   Begin by initializing the Taly SDK with the necessary credentials. You'll need the following information:

   * **Username**: Your username for authentication.
   * **Password**: Your password for authentication.
   * **Environment**: Choose between Environment.Development for development and testing, or Environment.Production for the live app. 

```swift
import TalySdk

func xyzMethod() {
...
    // Replace the following lines with your actual data
    
    let tokenRequest = TokenRequest(username: "YOUR_USER_NAME",                                 password: "YOUR_PASSWORD", 
                                    grantType: "password", 
                                    scope: "api")

    let psp = PSP(isPspOrder: true, 
                  pspProvider: "",
                  subMerchantId: 0,
                  subMerchantName: "")
                  
    let orderItem = OrderItem(sku: "23433312436",
                              type: "Digital",
                              name: "lue shirt 998",
                              itemDescription: "t-shirt made of cotton",
                              quantity: 1,
                              itemPrice: 1.000,
                              imageUrl: "https://www.merchantwebsite.com/item1image.jpg",
                              itemUrl: "https://www.merchantwebsite.com/item1.html",
                              itemUnit: "gm",
                              itemSize: "32",
                              itemColor: "white",
                              itemGender: "kids",
                              itemBrand: "Adidas",
                              itemCategory: "Men>Men's Shoes>Running",
                              currency: "KWD")

    let customerDetail = CustomerDetails(firstName: "Ahmaa",
                                         lastName: "Ali",
                                         gender: "Male",
                                         phoneNumber: "502223333",
                                         customerEmail: "user@example.com",
                                         registeredSince: "2023-07-22",
                                         loyaltyMember: true,
                                         loyaltyLevel: "VIP")

    let deliveryAddress = DeliveryAddress(city: "Hawalli",
                                          area: "Salmiya",
                                          fullAddress: "Hawlli, salmiya, block 5, building 5, floor 2, flat 6",
                                          phoneNumber: "502223333",
                                          customerEmail: "user@example.com")


    let merchantId =  "CurrentTime_In_Milliseconds"

    let orderRequest = OrderRequest(merchantOrderId: merchantId,
                                    language: "en",
                                    subtotal: 1.00, totalAmount: 1.000,
                                    currency: "KWD",
                                    discountAmount: 0.00,
                                    taxAmount: 0.000,
                                    deliveryAmount: 0.000,
                                    deliveryMethod: "home
                                    delivery",
                                    otherFees: 0.00, 
                                    psp: psp,
                                    orderItems: [orderItem],
                                    isDigitalOrder: false,
                                    customerDetails: customerDetail,
                                    deliveryAddress: deliveryAddress,
                                    merchantRedirectURL: "https://yourmerchant.com/checkout/",
                                    postBackUrl: "https://yourmerchant.com/yourWebwebhookEndpoint/",
                                    merchantLogo: "https://www.yourmerchant.com/media/merchantLogo.png")

    let viewController = PlaceOrderView(orderRequest:orderRequest,
                                        tokenRequest: tokenRequest,
                                        environment: userData.environment == "Development" ? URLHost.dev : URLHost.production)

        Then set the delegate on the viewController:

        viewController.delegate = self
...
}
```

## delegate

TalySdk provides delegate methods for order success, failure and error transition process through the PlaceOrderDelegate protocol.

public protocol PlaceOrderDelegate: AnyObject {

    /// This method is called when the place order process is completed successfully.
    func didFinishPlaceOrderWithSuccess(successOrderDetails: OrderDetails)
    
    /// This method is called when an error occurs during the place order process.
    func didFinishPlaceOrderWithError(error: OtherErrorResponse)

    /// This method is called when the place order process fails for some reason.
    func didFinishPlaceOrderWithFailure(failureOrderDetail: OrderDetails)
}


### Additional
---

1. You can customize the color of the TalySDK ActivityIndicatorColor according to your app's design:

   * Change ActivityIndicator Color: To change the color, use the activityIndicatorColor property of the TalySdk:

       ```
        viewController.activityIndicatorColor = .themeColor // Replace 'yourColor' with the desired color resource
       ```
2. You can enable language selection for your users to choose between English and Arabic. First, ensure that your application supports both languages.


## Banner View Integration

Integrate the Banner view into your Product Detail screen to offer users a comprehensive, step-by-step guide on utilizing the Taly Payment System. This feature will also visually present the product amount divided into four manageable installments.

    ```
    var sdkBannerView = BannerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 58),
                                   userName: "YOUR_USER_NAME",
                                   password: "YOUR_PASSWORD",
                                   name: "",
                                   quantity: 1,
                                   amount: "YOUR_AMOUNT",
                                   currency: "KD")
        sdkBannerView?.delegate = self
        
     // Enable custom view for Banner installments
        sdkBannerView?.isShowCustomView = true   
    ```   
        
Additionally, the Taly SDK extends the capability to exhibit Banner installments even without the view. The default behavior of isShowCustomView is set to false, allowing you to choose between a standard or custom visualization.


             
## Delegate Interaction

The integration introduces delegate methods to facilitate seamless communication with the Banner view, empowering you to customize the display of installments data.
 

## Banner Response for Custom view

TalySdk offers a function to retrieve Banner installments without the view, useful for displaying a custom banner. Delegate methods are provided to access the required details for displaying data on the view.The BannerViewDelegate protocol exposes essential delegate methods for accessing the necessary data to populate your custom view.


public protocol BannerViewDelegate: AnyObject {

    // Invoked when custom banner details are fetched
    func didGetBannerDetail(bannerResponse: [BannerResponse])
    
    // Triggered upon encountering an error during data retrieval
    func didGetError()
    
    // Called when the info button is tapped, returning a URL
    func didInfoButtonTap(url: String)
}

Integrate these delegate methods to effortlessly interact with the Banner view
