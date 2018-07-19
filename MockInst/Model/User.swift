//
//  User.swift
//  MockInst
//
//  Created by Sinisa Vukovic on 16/07/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation

struct User:Decodable,Encodable {
   var bio:String?
   var counts:Counts?
   var full_name:String?
   var id:String?
   var is_business:Bool?
   var profile_picture:String?
   var username:String?
   var website:String?
}

struct Counts:Decodable,Encodable {
   var followed_by:Int?
   var follows:Int?
   var media:Int?
}
