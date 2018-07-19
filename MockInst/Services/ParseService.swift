//
//  ParseService.swift
//  MockInst
//
//  Created by Sinisa Vukovic on 18/07/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation

class ParseService {
   
   static func parseUserInfo(dict:[String:Any]) -> User? {
      if let data = dict["data"] {
         var user = User()
         if let d = data as? [String:Any] {
            if let bio = d["bio"] as? String{
               user.bio = bio
            }
            if let counts = d["counts"] as? [String:Any]{
               var c = Counts()
               if let followedBy = counts["followed_by"] as? Int {
                  c.followed_by = followedBy
               }
               if let media = counts["media"] as? Int {
                  c.media = media
               }
               if let follows = counts["follows"] as? Int {
                  c.follows = follows
               }
               user.counts = c
            }
            if let fullName = d["full_name"] as? String{
               user.full_name = fullName
            }
            if let id = d["id"] as? String{
               user.id = id
            }
            if let is_business = d["is_business"] as? Bool {
               user.is_business = is_business
            }
            if let username = d["username"] as? String {
               user.username = username
            }
            if let website = d["website"] as? String {
               user.website = website
            }
            if let pictureUrl = d["profile_picture"] as? String{
               user.profile_picture = pictureUrl
            }
            return user
         }
      }else {
         return nil
      }
      return nil
   }
   
   static func parseRecentsInfo(dict:[String:Any]) -> [Recent]?{
      if let data = dict["data"] {
         var recents:[Recent] = []
         if let arrayOfRecents = data as? [[String:Any]] {
            for recent in arrayOfRecents {
               var recentObject = Recent()
               if let caption = recent["caption"] as? [String:Any] {
                  if let from = caption["from"] as? [String:Any] {
                     var user = User()
                     if let username = from["username"] as? String {
                        user.username = username
                     }
                     if let profilePicture = from["profile_picture"] as? String {
                        user.profile_picture = profilePicture
                     }
                     recentObject.user = user
                  }
                  if let title = caption["text"] as? String{
                     recentObject.title = title
                  }
               }
               
               if let likes = recent["likes"] as? [String:Any] {
                  if let likesNumber = likes["count"] as? Int{
                     recentObject.likes = likesNumber
                  }
               }
               
               if let location = recent["location"] as? [String:Any] {
                  if let locationName = location["name"] as? String {
                     recentObject.location = locationName
                  }
               }
               
               if let images = recent["images"] as? [String:Any] {
                  if let largeImage = images["standard_resolution"] as? [String:Any] {
                     if let imageUrl = largeImage["url"] as? String {
                        recentObject.imageUrl = imageUrl
                     }
                  }
               }
               recents.append(recentObject)
            }
         }
         if recents.count > 0 {
            return recents
         }else {
            return nil
         }
      }
      return nil
   }
}
