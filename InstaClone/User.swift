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
    var screenName : String?
    var desc : String?
    var profileImageURL : String?
    
    init( ) {
        id = ""
        email = ""
        name = ""
        screenName = ""
        desc = ""
        profileImageURL = ""
    }
    
    init(withAnId : String, anEmail : String, aName : String, aScreenName : String, aDesc : String, aProfileImageURL : String) {
        id = withAnId
        email = anEmail
        name = aName
        screenName = aScreenName
        desc = aDesc
        profileImageURL = aProfileImageURL
    }
    
    init(dictionary: [String: AnyObject]) {
        id = (dictionary["id"] as? String)!
        name = (dictionary["name"] as? String)!
        screenName = "Anonymous"
        email = (dictionary["email"] as? String)!
        desc = "I'm using InstaClone"
        profileImageURL = (dictionary["profileImageURL"] as? String)!
    }
    
}
