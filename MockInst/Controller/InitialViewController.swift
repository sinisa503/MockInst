//
//  ViewController.swift
//  MockInst
//
//  Created by Sinisa Vukovic on 15/07/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

   @IBOutlet weak var loginButton: UIButton!
   
   var webViewVC: WebViewViewController?
   override func viewDidLoad() {
      super.viewDidLoad()
      
      loginButton.layer.cornerRadius = loginButton.bounds.height / 2
      loginButton.layer.masksToBounds = true
   }
   
   @IBAction func loginAction(_ sender: UIButton) {
      let instagramService = InstagramService.shared
      let authURL = instagramService.buildAuthURL(scopes: [.basic])
      webViewVC = WebViewViewController(authURL: authURL, success: {[weak self] accessToken in
         print("Access token: \(accessToken)")
         instagramService.setUserLoggedIn(with: accessToken)
         self?.goToMainVC()
      }) {[weak self] instagramError in
         self?.showErrorAlert(title: "Error", message: instagramError.localizedDescription)
      }
      if let webVC = webViewVC {
         present(webVC, animated: true, completion: nil)
      }else {
         showErrorAlert(title: "Error", message: "Error presenting web view")
      }
   }
   
   private func goToMainVC() {
      self.webViewVC?.dismiss(animated: true, completion: {
         let mainVC = UIStoryboard(name: Constants.MAIN_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.TAB_BAR_STORYBOARD_NAME)
         self.present(mainVC, animated: true, completion: nil)
      })
   }
   
   private func showErrorAlert(title:String, message:String) {
      self.webViewVC?.dismiss(animated: true, completion: {
         let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
         alertVC.addAction(UIAlertAction(title: "OK", style: .default , handler: nil))
         self.show(alertVC, sender: nil)
      })
   }
}

