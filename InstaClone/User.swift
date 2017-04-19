//
//  User.swift
//  SimpleFirebase
//
//  Created by bitbender on 4/6/17.
//  Copyright © 2017 Key. All rights reserved.
//

import Foundation

class User {

    var id: String?
    var email : String?
    var name : String?
    var userName : String?
    var desc : String?
    var profileImageUrl : String?
    
    init( ) {
        id = ""
        email = ""
        name = ""
        userName = ""
        desc = ""
        profileImageUrl = ""
    }

    init(withAnId : String, anEmail : String, aName : String, aScreenName : String, aDesc : String, aProfileImageURL : String) {
        id = withAnId
        email = anEmail
        name = aName
        userName = aScreenName
        desc = aDesc
        profileImageUrl = aProfileImageURL
    }
    
    init(dictionary: [String: AnyObject]) {
        id = dictionary["id"] as? String
        name = dictionary["name"] as? String
        userName = "Anonymous"
        email = dictionary["email"] as? String
        desc = "I'm using InstaClone"
        profileImageUrl = dictionary["profileImageUrl"] as? String
    }
    
}
