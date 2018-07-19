//
//  DownloadService.swift
//  MockInst
//
//  Created by Sinisa Vukovic on 16/07/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation
import UIKit

typealias DownloadImageCompletion = (_ image:UIImage?,_ error:Error?)->()

class DownloadService {
   
   static let shared = DownloadService()
   private init(){}
   
   static func downloadImageFrom(url:String, completion:@escaping DownloadImageCompletion) {
      DispatchQueue.global().asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 500) , qos: .background) {
         if let url = URL(string: url) {
            do {
               let data = try Data(contentsOf: url)
               if let image = UIImage(data: data) {
                  DispatchQueue.main.async {
                     completion(image,nil)
                  }
               }
            }catch let error {
               DispatchQueue.main.async {
                  completion(nil, error)
               }
            }
         }
      }
   }
   
}
