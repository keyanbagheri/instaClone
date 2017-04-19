//
//  Comment.swift
//  InstaClone
//
//  Created by ardMac on 19/04/2017.
//  Copyright © 2017 teamHearts. All rights reserved.
//

import Foundation
import Firebase

class Comment {
    var id : String?
    var userId: String?
    var userName : String?
    var userProfileImageUrl : String?
    var text: String?
    var timestamp: String?
    
    init( ) {
        id = ""
        userId = ""
        userName = ""
        userProfileImageUrl = ""
        text = ""
        timestamp = ""
    }
    
    init(withAnId : String, aUserId : String, aUserName : String, aUserProfileImageUrl : String, aText : String, aTimestamp : String) {
        id = withAnId
        userId = aUserId
        userName = aUserName
        userProfileImageUrl = aUserProfileImageUrl
        text = aText
        timestamp = aTimestamp
    }

}
