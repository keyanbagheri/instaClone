//
//  Photo.swift
//  InstaClone
//
//  Created by bitbender on 4/15/17.
//  Copyright © 2017 teamHearts. All rights reserved.
//

import Foundation

class Photo {
    var id: String?
    var userId : String?
    var userName:String?
    var postImageUrl: String?
    var userProfileImageUrl: String?
    var numberOfLikes: Int?
    var location: String?
    var timeStamp: String?
    
    init( ) {
        id = ""
        userId = ""
        userName = ""
        location = ""
        postImageUrl = ""
        userProfileImageUrl = ""
        numberOfLikes = 0
        timeStamp = ""
    }
    
    init(dictionary: [String: AnyObject]) {
        
        self.id = dictionary["id"] as? String
        self.userId = dictionary["userId"] as? String
        self.userName = dictionary["userName"] as? String
        //self.caption = dictionary["caption"] as? String
        self.postImageUrl = dictionary["postImageUrl"] as? String
        self.userProfileImageUrl = dictionary["userProfileImageURL"] as? String
        self.numberOfLikes = dictionary["numberOfLikes"] as? Int
    }
    
    init(withAnId : String, aUserID : String, aUserName : String, aLocation : String, aPostImageURL : String, aUserProfileImageURL : String, aTimeStamp : String) {
        id = withAnId
        userId = aUserID
        userName = aUserName
        location = aLocation
        postImageUrl = aPostImageURL
        userProfileImageUrl = aUserProfileImageURL
        timeStamp = aTimeStamp
    }
}
