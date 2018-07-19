//
//  RecentsViewController.swift
//  MockInst
//
//  Created by Sinisa Vukovic on 18/07/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import UIKit

class RecentsViewController: UIViewController {
   
   @IBOutlet weak var tableView: UITableView!
   
   private let instagramService = InstagramService.shared
   private var recents:[Recent] = [] {
      didSet {
         DispatchQueue.main.async {
            self.tableView.reloadData()
         }
      }
   }
   
    override func viewDidLoad() {
        super.viewDidLoad()

      tableView.allowsSelection = false
      loadRecents()
    }
   
   
   private func loadRecents() {
      instagramService.getUserRecents { recents in
         if let arrayOfRecents = recents {
            self.recents = arrayOfRecents
         }
      }
   }
}

extension RecentsViewController: UITableViewDelegate, UITableViewDataSource {
   
   func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return recents.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      if let cell = tableView.dequeueReusableCell(withIdentifier: RecentTableViewCell.IDENTIFIER) as? RecentTableViewCell {
         cell.configure(with: recents[indexPath.row])
         return cell
      }else {
         return UITableViewCell()
      }
   }
   
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return UIScreen.main.bounds.height * 0.8
   }
}
