//
//  ViewController.swift
//  webViewCheckout
//
//  Created by Stoyan Kolev on 6.04.22.
//  Copyright © 2022 Stoyan Kolev. All rights reserved.
//

import UIKit
import WebKit

let sampleURL = URL(string: "https://devmobile.sccdev-qa.com/checkoutNext/")!
let requestURL = URLRequest(url: sampleURL)

class ViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var backwardButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var popupWebViews = [WKWebView]()
    var popupWebView: WKWebView?
    var currentWebView: WKWebView {
        return popupWebViews.isEmpty ? webView : popupWebViews.last!
    }
    
    
    var urlPath: String = "https://devmobile.sccdev-qa.com/checkoutNext/"
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        loadWebView()
    }
    
    func setupWebView() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.uiDelegate = self
        webView.navigationDelegate = self
        
        view.addSubview(webView)
    }
    
    func loadWebView() {
            currentWebView.load(requestURL)
        
    }
    
    @IBAction func tapHomeButton(_ sender: UIBarButtonItem) {
        currentWebView.load(requestURL)
    }
    
    @IBAction func tapRefreshButton(_ sender: UIBarButtonItem) {
        currentWebView.reload()
    }
}

extension ViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        popupWebView = WKWebView(frame: webView.frame, configuration: configuration)
//        popupWebView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        popupWebView!.navigationDelegate = self
        popupWebView!.uiDelegate = self
//        popupWebView?.translatesAutoresizingMaskIntoConstraints = false
        popupWebView?.allowsBackForwardNavigationGestures = true
        view.addSubview(popupWebView!)
        //popupWebViews.append(popupWebView!)
        return popupWebView!
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        webView.removeFromSuperview()
        popupWebView = nil
    }
}
