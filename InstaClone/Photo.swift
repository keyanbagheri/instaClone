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
    var imagePostURL : String
    var imageProfileURL : String
    var caption : String
    var timeStamp : String
    
    init( ) {
        id = ""
        userID = ""
        userName = ""
        location = ""
        imagePostURL = ""
        imageProfileURL = ""
        caption = ""
        timeStamp = ""
    }
    
    init(withAnId : String, aUserID : String, aUserName : String, aLocation : String, anImagePostURL : String, anImageProfileURL : String, aCaption : String, aTimeStamp : String) {
        id = withAnId
        userID = aUserID
        userName = aUserName
        location = aLocation
        imagePostURL = anImagePostURL
        imageProfileURL = anImageProfileURL
        caption = aCaption
        timeStamp = aTimeStamp
    }
}
