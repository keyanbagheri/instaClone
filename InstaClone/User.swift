//
//  User.swift
//  
//
//  Created by bitbender on 4/15/17.
//
//

import Foundation

class User {
    var id: String
    var email: String
    var name: String
    var desc: String
    var imageURL: String
    
    init() {
        id = ""
        email = ""
        name = ""
        desc = ""
        imageURL = ""
    }
    
    init(withAnID : String, anEmail : String, aName : String, aDesc : String, anImageURL : String) {
        id = withAnID
        email = anEmail
        name = aName
        desc = aDesc
        imageURL = anImageURL
    }
    

}
