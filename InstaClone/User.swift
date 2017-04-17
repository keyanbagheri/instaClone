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
    var desc : String?
    var profileImageURL : String?
    
    init( ) {
        id = ""
        email = ""
        name = ""
        desc = ""
        profileImageURL = ""
    }
    
    init(withAnId : String, anEmail : String, aName : String, aDesc : String, aProfileImageURL : String) {
        id = withAnId
        email = anEmail
        name = aName
        desc = aDesc
        profileImageURL = aProfileImageURL
    }
    
    init(dictionary: [String: AnyObject]) {
        id = (dictionary["id"] as? String)!
        name = (dictionary["name"] as? String)!
        email = (dictionary["email"] as? String)!
        desc = "I'm using InstaClone"
        profileImageURL = (dictionary["profileImageUrl"] as? String)!
    }
    
}
