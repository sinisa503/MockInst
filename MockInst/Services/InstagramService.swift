//
//  InstagramLoginService.swift
//  MockInst
//
//  Created by Sinisa Vukovic on 15/07/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
   case get = "GET", post = "POST", delete = "DELETE"
}

enum InstagramError: Error {
   case badRequest
   case decoding(message: String)
   case invalidRequest(message: String)
   case keychainError(code: OSStatus)
   case missingClientIdOrRedirectURI
}

class InstagramService {
   
   private let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize"
   private let BASE_URL = "https://api.instagram.com/v1"
   private let CLIENT_ID = "f667d8cf793841a397540b1a18bb74df"
   private let SUPPORT_EMAIL = "sinisa503@icloud.com"
   private let CLIENT_STATUS = "Sandbox Mode"
   private let REDIRECT_URI = "https://www.tvornica-snova.hr/uvjeti-prodaje"
   private let INSTAGRAM_SCOPE = "follower_list+public_content"
   private let ACCESS_TOKEN_DEFAULTS_VALUE = "access.token.defaults"
   
    var isUserLoggedIn:Bool {
      get {
         if accessToken == nil {
            return false
         }else {
            return true
         }
      }
   }
   
    func setUserLoggedIn(with accessToken:String) {
      UserDefaults.standard.set(accessToken, forKey: ACCESS_TOKEN_DEFAULTS_VALUE)
   }
   
    func setUserLoggedOut() {
      UserDefaults.standard.removeObject(forKey: ACCESS_TOKEN_DEFAULTS_VALUE)
   }
   
   private  var accessToken:String? {
      get {
         if let token = UserDefaults.standard.string(forKey: ACCESS_TOKEN_DEFAULTS_VALUE) {
            return token
         }else {
            return nil
         }
      }
   }
   
   func getUserInfo(success:@escaping (_ user:User?)->()) {
      let string = "https://api.instagram.com/v1/users/self/"
      var urlComp = URLComponents(string: string)
      let queryItems = [URLQueryItem(name: "access_token", value: accessToken)]
      urlComp?.queryItems = queryItems
      let request = URLRequest(url: (urlComp?.url)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
      let config = URLSessionConfiguration.default
      let session = URLSession(configuration: config)
      let task = session.dataTask(with: request) { (data, response, error) in
         if error == nil {
            do {
               guard let dict = try JSONSerialization.jsonObject(with: data!, options: [])
                  as? [String: Any] else {
                     print("error trying to convert data to JSON")
                     return
               }
               if let user = ParseService.parseUserInfo(dict: dict) {
                  success(user)
               }else {
                  success(nil)
               }
            }catch let error{
               print(error.localizedDescription)
            }
         }else {
            print(error.debugDescription)
         }
      }
      task.resume()
   }
   
   func getUserRecents(success:@escaping (_ user:[Recent]?)->()) {
      let string = "https://api.instagram.com/v1/users/self/media/recent"
      var urlComp = URLComponents(string: string)
      let queryItems = [URLQueryItem(name: "access_token", value: accessToken)]
      urlComp?.queryItems = queryItems
      let request = URLRequest(url: (urlComp?.url)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
      let config = URLSessionConfiguration.default
      let session = URLSession(configuration: config)
      let task = session.dataTask(with: request) { (data, response, error) in
         if error == nil {
            do {
               guard let dict = try JSONSerialization.jsonObject(with: data!, options: [])
                  as? [String: Any] else {
                     print("error trying to convert data to JSON")
                     return
               }
               if let recents = ParseService.parseRecentsInfo(dict: dict) {
                  success(recents)
               }else {
                  success(nil)
               }
            }catch let error{
               print(error.localizedDescription)
            }
         }else {
            print(error.debugDescription)
         }
      }
      task.resume()
   }
   
   func buildAuthURL(scopes: [InstagramScope]) -> URL {
      var components = URLComponents(string: INSTAGRAM_AUTHURL)!
      
      components.queryItems = [
         URLQueryItem(name: "client_id", value: CLIENT_ID),
         URLQueryItem(name: "redirect_uri", value: REDIRECT_URI),
         URLQueryItem(name: "response_type", value: "token"),
         URLQueryItem(name: "scope", value: scopes.map({$0.rawValue}).joined(separator: "+"))
      ]
      
      return components.url!
   }
   
   static let shared = InstagramService()
   private init() {}
}
