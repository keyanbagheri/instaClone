//
//  TimeLineViewController.swift
//  InstaClone
//
//  Created by Arkadijs Makarenko on 18/04/2017.
//  Copyright © 2017 teamHearts. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class TimeLineViewController: UIViewController {

    var picturePost: [Photo] = []
    var ref: FIRDatabaseReference!
    var currentUser : FIRUser? = FIRAuth.auth()?.currentUser
    var currentUserID : String = ""
    var lastPostID : Int = 0
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.register(TimeLineTableViewCell.cellNib, forCellReuseIdentifier: TimeLineTableViewCell.cellIdentifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ref = FIRDatabase.database().reference()
        if let id = currentUser?.uid {
            print(id)
            currentUserID = id
        }
     
        listenToFirebase()
    }
    
    func listenToFirebase() {
        ref.child("posts").observe(.value, with: { (snapshot) in
            print("Value : " , snapshot)
        })
        
        // 2. get the snapshot
        ref.child("posts").observe(.childAdded, with: { (snapshot) in
            print("Value : " , snapshot)
            
            // 3. convert snapshot to dictionary
            guard let info = snapshot.value as? NSDictionary else {return}
            // 4. add to array of messages
            self.addToPersonalPost(id: snapshot.key, postInfo: info)
            
            // sort
            self.picturePost.sort(by: { (picture1, picture2) -> Bool in
                return picture1.id > picture2.id
                
                //LATER NEED TO CHANGE TO SORT BY POST TIME
            })
            
            // set last message id to last id
//            if let lastPost = self.picturePost.last {
//                self.lastPostID = lastPost.id
//            }
//            
            // 5. update table view
            self.tableView.reloadData()
            
        })
        
    }
    
    func addToPersonalPost(id : Any, postInfo : NSDictionary) {
        
        if let userID = postInfo["userID"] as? String,
            let caption = postInfo["caption"] as? String,
            let profilePictureURL = postInfo["profileImageURL"] as? String,
            let timeStamp = postInfo["timestamp"] as? String,
            let postID = id as? String,
//            let currentPostID = Int(postID),
            let imagePostURL =  postInfo["postedImageURL"] as? String,
            let username = postInfo["screenName"] as? String,
            let location = postInfo["location"] as? String {
            
            let newPost = Photo(withAnId: postID, aUserID: userID, aUserName: username, aLocation: location, anImagePostURL: imagePostURL, anImageProfileURL: profilePictureURL, aCaption: caption, aTimeStamp: timeStamp)
            
            self.picturePost.append(newPost)
            
        }
        
    }

}


extension TimeLineViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return picturePost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimeLineTableViewCell.cellIdentifier) as? TimeLineTableViewCell
        else { return UITableViewCell()}
        
        let currentPost = picturePost[indexPath.row]
        
        let picturePostURL = currentPost.imagePostURL
        let profilePictureURL = currentPost.imageProfileURL
        
        cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profilePictureURL)
        cell.postImageiew.loadImageUsingCacheWithUrlString(urlString: picturePostURL)
        cell.userNameLabel.text = currentPost.userName
        cell.captionTextView.text = currentPost.caption
    
        
         return cell
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 600
    }
    
    
    }







