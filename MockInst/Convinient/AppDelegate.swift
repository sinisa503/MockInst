//
//  AppDelegate.swift
//  MockInst
//
//  Created by Sinisa Vukovic on 15/07/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?
   let instagramService = InstagramService.shared

   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
      window = UIWindow(frame: UIScreen.main.bounds)
      
      if instagramService.isUserLoggedIn {
         showMainVC()
      }else {
         showLoginVC()
      }      
      return true
   }
   
   private func showMainVC() {
      let mainVC = UIStoryboard(name: Constants.MAIN_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.TAB_BAR_STORYBOARD_NAME)
      window?.rootViewController = mainVC
   }

   private func showLoginVC() {
      let loginVC = UIStoryboard(name: Constants.MAIN_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.LOGIN_NAV_CONTROLLER_ID)
      window?.rootViewController = loginVC
   }
}

