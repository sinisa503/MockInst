//
//  MainViewController.swift
//  MockInst
//
//  Created by Sinisa Vukovic on 16/07/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

   private let instagramService = InstagramService.shared
   
   @IBOutlet weak var userNameLabel: UILabel!
   @IBOutlet weak var imageView: UIImageView!
   @IBOutlet weak var followedLabel: UILabel!
   @IBOutlet weak var folowsLabel: UILabel!
   @IBOutlet weak var mediaLabel: UILabel!
   @IBOutlet weak var biografyLabel: UILabel!
   
   override func viewDidLoad() {
        super.viewDidLoad()

      instagramService.getUserInfo {[weak self] (user) in
         DispatchQueue.main.async {
            self?.userNameLabel.text = user?.username
            if let followed = user?.counts?.followed_by {
               self?.followedLabel.text = String(followed)
            }
            if let follows = user?.counts?.follows {
               self?.folowsLabel.text = String(follows)
            }
            if let media = user?.counts?.media {
               self?.mediaLabel.text = String(media)
            }
            if let imageUrl = user?.profile_picture {
               self?.getUserImage(from: imageUrl)
            }
            if let biografy = user?.bio {
               if biografy == "" {
                  self?.biografyLabel.text = "No biografy"
               }else {
                  self?.biografyLabel.text = biografy
               }
            }
         }
      }
    }
   
   private func getUserImage(from url:String) {
      DownloadService.downloadImageFrom(url: url) {[weak self] (image, error) in
         guard error == nil, let image = image else { return }
         self?.imageView.image = image
      }
   }

   @IBAction func logOut(_ sender: UIButton) {
      instagramService.setUserLoggedOut()
      self.dismiss(animated: true, completion: nil)
      let loginVC = UIStoryboard(name: Constants.MAIN_STORYBOARD_NAME, bundle: nil).instantiateViewController(withIdentifier: Constants.LOGIN_NAV_CONTROLLER_ID)
      self.present(loginVC, animated: true, completion: nil)
   }
}
