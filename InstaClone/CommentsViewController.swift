//
//  CommentsViewController.swift
//  InstaClone
//
//  Created by ardMac on 18/04/2017.
//  Copyright © 2017 teamHearts. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase

class CommentsViewController: UIViewController {
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentsTableView: UITableView! {
        didSet{
            commentsTableView.delegate = self
            commentsTableView.dataSource = self
            
            commentsTableView.register(CommentsTableViewCell.cellNib, forCellReuseIdentifier: CommentsTableViewCell.cellIdentifier)
        }
    }
    var currentUser : FIRUser? = FIRAuth.auth()?.currentUser
    var currentUserName = "Anonymous"
    
    var comments = [Comment]()
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set value for user
        ref = FIRDatabase.database().reference()
        observeComments()
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        handleSend()
    }
    
    
//    var user: User? {
//        didSet {
//            observeComments()
//        }
//    }
//
//    func getUserName () {
//        ref.child("users").child((currentUser?.uid)!).observe(.value, with: { (snapshot) in
//            print("Value : " , snapshot)
//            
//            let dictionary = snapshot.value as? [String: Any]
//            if let userName = dictionary?["userName"] as? String {
//                self.currentUserName = userName
//            }
//        })
//    }
    
    func observeComments() {
        ref.child("posts").child("-Ki3oZKYFTDAFp49sve_").child("comments").observe(.value, with: { (snapshot) in
            print(snapshot)
            
            guard let comments = snapshot.value as? NSDictionary else {return}
            
            for (k, v) in comments {
                
                if let commentId = k as? String,
                   let dictionary = v as? [String: Any] {
                    self.addToComments(id: commentId, commentInfo: dictionary as NSDictionary)
                }
                
            }
            self.commentsTableView.reloadData()

        })
    }
    
    
    func handleSend() {
        let ref = FIRDatabase.database().reference().child("posts").child("-Ki3oZKYFTDAFp49sve_").child("comments")
        let childRef = ref.childByAutoId()
        let values: [String: Any] = ["text": commentTextField.text! as String, "userName": currentUserName as String, "userId": "3DqqiWKvSzPf2Lwy7WllKxOcOB83", "timestamp": "\(NSNumber(value: Int(Date().timeIntervalSince1970)))"]
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            //let recipientUserCommentsRef = FIRDatabase.database().reference().child("user-comments").child(toId)
            //recipientUserCommentsRef.updateChildValues([commentId: 1])
        }
    }
    
    func addToComments(id : String, commentInfo: NSDictionary) {
        if let userName = commentInfo["userName"] as? String,
           let userId = commentInfo["userId"] as? String,
           let userProfileImageUrl = commentInfo["userProfileImageUrl"] as? String,
           let text = commentInfo["text"] as? String,
           let timestamp = commentInfo["timestamp"] as? String {
                let newComment = Comment(withAnId: id, aUserId: userId, aUserName: userName, aUserProfileImageUrl: userProfileImageUrl, aText: text, aTimestamp: timestamp)
                self.comments.append(newComment)
        }
    }

}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentsTableViewCell.cellIdentifier) as? CommentsTableViewCell
            else { return UITableViewCell()}
        let currentComment = comments[indexPath.row]
        let profilePicURL = currentComment.userProfileImageUrl
//        cell.commentsTextView.allowsEditingTextAttributes = true
        cell.commentsTextView.text = currentComment.text
        cell.usernameLabel.text = currentComment.userName
        cell.imageView?.loadImageUsingCacheWithUrlString(urlString: profilePicURL!)
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 600
//    }
    
    
}








