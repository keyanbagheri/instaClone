//
//  Photo.swift
//  InstaClone
//
//  Created by bitbender on 4/15/17.
//  Copyright © 2017 teamHearts. All rights reserved.
//

import Foundation

class Photo {
    var id: String
    var userID : String
    var userName : String
    var location : String
    var imageURL : String
    var timeStamp : String
    
    init( ) {
        id = ""
        userID = ""
        userName = ""
        location = ""
        imageURL = ""
        timeStamp = ""
    }
    
    init(withAnId : String, aUserID : String, aUserName : String, aLocation : String, anImageURL : String, aTimeStamp : String) {
        id = withAnId
        userID = aUserID
        userName = aUserName
        location = aLocation
        imageURL = anImageURL
        timeStamp = aTimeStamp
    }
}
