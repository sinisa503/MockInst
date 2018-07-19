//
//  RecentTableViewCell.swift
//  MockInst
//
//  Created by Sinisa Vukovic on 18/07/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class RecentTableViewCell: UITableViewCell {
   
   static let IDENTIFIER = "recentTableViewCell"

   @IBOutlet weak var mainUserImageView: UIImageView!
   @IBOutlet weak var mainUserNameLabel: UILabel!
   @IBOutlet weak var mainPlaceFromLabel: UILabel!
   @IBOutlet weak var largeMiddleImageView: UIImageView!
   @IBOutlet weak var likedByUsernamesLabel: UILabel!
   @IBOutlet weak var recentTitle: UILabel!
   @IBOutlet weak var userNameLabel: UILabel!
   
   
   public func configure(with recent:Recent) {
      mainUserNameLabel.text = recent.user?.username
      mainPlaceFromLabel.text = recent.location
      if let likesNumber = recent.likes {
         likedByUsernamesLabel.text = "\(likesNumber) people"
      }
      recentTitle.text = recent.title
      if let userProfileImageUrl = recent.user?.profile_picture {
         getUserImage(from: userProfileImageUrl) {[weak self] (image, _) in
            self?.mainUserImageView.image = image
         }
      }
      if let userLargeImageUrl = recent.imageUrl {
         getUserImage(from: userLargeImageUrl) {[weak self] (image, _) in
            self?.largeMiddleImageView.image = image
         }
      }
      if let userName = recent.user?.username {
         userNameLabel.text = userName
      }
   }
   
   override func layoutSubviews() {
      super.layoutSubviews()
      mainUserImageView.layer.cornerRadius = mainUserImageView.bounds.size.height / 2
      mainUserImageView.layer.masksToBounds = true
   }

   private func getUserImage(from url:String, completion:@escaping DownloadImageCompletion) {
      DownloadService.downloadImageFrom(url: url) {(image, error) in
         completion(image,error)
      }
   }
}
