//
//  WebViewViewController.swift
//  MockInst
//
//  Created by Sinisa Vukovic on 15/07/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {
   
   typealias SuccessHandler = (_ accesToken: String) -> Void
   typealias FailureHandler = (_ error: InstagramError) -> Void
   
   private var authURL: URL
   private var success: SuccessHandler?
   private var failure: FailureHandler?
   
   init(authURL: URL, success: SuccessHandler?, failure: FailureHandler?) {
      self.authURL = authURL
      self.success = success
      self.failure = failure
      
      super.init(nibName: nil, bundle: nil)
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   override func viewDidLoad() {
        super.viewDidLoad()

      let webView = setupWebView()
      webView.load(URLRequest(url: authURL, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData))
    }
   
   private func setupWebView() -> WKWebView {
      let webConfiguration = WKWebViewConfiguration()
      webConfiguration.websiteDataStore = .nonPersistent()
      
      let webView = WKWebView(frame: view.frame, configuration: webConfiguration)
      webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      webView.navigationDelegate = self
      
      view.addSubview(webView)
      
      return webView
   }
}

extension WebViewViewController: WKNavigationDelegate {
   
   func webView(_ webView: WKWebView,
                decidePolicyFor navigationAction: WKNavigationAction,
                decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
      
      let urlString = navigationAction.request.url!.absoluteString
      
      guard let range = urlString.range(of: "#access_token=") else {
         decisionHandler(.allow)
         return
      }
      
      decisionHandler(.cancel)
      
      DispatchQueue.main.async {
         self.success?(String(urlString[range.upperBound...]))
      }
   }
   
   func webView(_ webView: WKWebView,
                decidePolicyFor navigationResponse: WKNavigationResponse,
                decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
      
      guard let httpResponse = navigationResponse.response as? HTTPURLResponse else {
         decisionHandler(.allow)
         return
      }
      
      switch httpResponse.statusCode {
      case 400:
         decisionHandler(.cancel)
         DispatchQueue.main.async {
            self.failure?(InstagramError.badRequest)
         }
      default:
         decisionHandler(.allow)
      }
   }
}
