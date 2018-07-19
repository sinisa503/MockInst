//
//  InstagramScope.swift
//  MockInst
//
//  Created by Sinisa Vukovic on 15/07/2018.
//  Copyright © 2018 Sinisa Vukovic. All rights reserved.
//

import Foundation
public enum InstagramScope: String {
   case basic
   case publicContent = "public_content"
   case followerList = "follower_list"
   case comments
   case relationships
   case likes
   case all = "basic+public_content+follower_list+comments+relationships+likes"
}
