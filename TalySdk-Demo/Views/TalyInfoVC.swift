//
//  TalyInfoVC.swift
//  DemoApp
//
//  Created by Taly on 18/08/23.
//

import Foundation
@preconcurrency import WebKit
import TalySdk

class TalyInfoVC: UIViewController, WKUIDelegate {
    
    // MARK: - variables
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let url: String?
    
    lazy var webView: WKWebView = {
        let webView = WKWebView(frame: self.view.frame)
        webView.backgroundColor = .white
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.allEdgeAnchor(to: self.view, top: 0, left: 0, right: 0, bottom: 0)
        webView.contentMode = .scaleAspectFit
        webView.uiDelegate = self
        webView.navigationDelegate = self
        return webView
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - view methods
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(webView)
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.white
            appearance.shadowColor = .clear
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        }
        self.title = "Taly"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(closedClicked))
        if let strUrl = self.url, let url = URL(string: strUrl) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    public init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: loader
    func startActivityIndicater() {
        self.webView.addSubview(activityIndicator)
        activityIndicator.centerXYAnchor(to: self.webView)
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicater() {
        activityIndicator.stopAnimating()
    }
    
    // MARK: User interaction
    @objc func closedClicked() {
        self.dismiss(animated: true)
    }
}

// MARK: - delegates
extension TalyInfoVC: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        
        decisionHandler(.allow)
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        
    }
}


extension UIActivityIndicatorView {
    func assignColor(_ color: UIColor) {
        style = UIActivityIndicatorView.Style.large
        self.color = color
    }
}

