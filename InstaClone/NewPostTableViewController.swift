//
//  NewPostTableViewController.swift
//  InstaClone
//
//  Created by Arkadijs Makarenko on 19/04/2017.
//  Copyright © 2017 teamHearts. All rights reserved.
//

import UIKit
import Firebase
class NewPostTableViewController: UITableViewController {
    
    var selectedImage: UIImage!
    var userName = ""
    var userProfilePicture = ""
    var postIsLiked = false
    var selectedPostID = ""
    var numberOfPostLikes = 0
    
    var currentUser : FIRUser? = FIRAuth.auth()?.currentUser
    var currentUserName : String = ""
    var currentUserID : String = ""
    var profileImageUrl : String = ""
    var comments = [Comment]()
    
    @IBOutlet weak var pickedImageView: UIImageView!
    
    @IBOutlet weak var captionTextField: UITextView!{
        didSet{
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(removePlaceholderText))
            captionTextField.isUserInteractionEnabled = true
            captionTextField.addGestureRecognizer(tapGestureRecognizer)
            
        }
    }
    
    func removePlaceholderText() {
        if captionTextField.text == "Write a caption..." {
            captionTextField.text = ""
            captionTextField.isUserInteractionEnabled = true
            captionTextField.font = captionTextField.font?.withSize(12)
            captionTextField.textColor = UIColor.black
        } else {
            return
        }
    }

    @IBAction func sharePost(_ sender: Any) {
        sharePost()
        shareCaption()
        //self.addToComments(id: snapshot.key, commentInfo: comments)
    }
    
    func shareCaption(){
        let ref = FIRDatabase.database().reference().child("posts").childByAutoId().child("comments")
        let childRef = ref.childByAutoId()
        let values: [String: Any] = ["text": captionTextField.text! as String, "userName": currentUserName as String, "userId": currentUser!.uid, "timestamp": "\(NSNumber(value: Int(Date().timeIntervalSince1970)))", "userProfileImageUrl": profileImageUrl as String]
        
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
    
    func sharePost(){
        if pickedImageView.image == UIImage(named: "ig"){
        }else{
              guard (FIRAuth.auth()?.currentUser?.uid) != nil else {return}
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("postsImages").child("\(imageName).jpeg")
            
            let image = self.pickedImageView.image
            guard let imageData = UIImageJPEGRepresentation(image!, 0.1) else { return }
            
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            storageRef.put(imageData, metadata: metaData, completion: { (metadata, error) in
                if error != nil {
                    print("Image error: \(error ?? "" as! Error)")
                    return
                }
                if let photoImageUrl = metadata?.downloadURL()?.absoluteString {
                    guard let userUid = FIRAuth.auth()?.currentUser?.uid else {return}
                    FIRDatabase.database().reference().child("users").child(userUid).observe(.value, with: { (snapshot) in
                        if let dictionary = snapshot.value as? [String: AnyObject] {
                            let user = User(dictionary: dictionary)//User(withID: snapshot.key, dictionary: dictionary)
                            user.id = snapshot.key
                            guard let username = user.name, let pic = user.profileImageUrl else{return}
                            self.userName = username
                            self.userProfilePicture = pic
                        }
                        //TODO:Add the liked bool and Int
                        let values = ["userId": userUid, "postImageUrl": photoImageUrl,"userName":self.userName, "userProfileImageURL":self.userProfilePicture, "likeImageIsTapped": self.postIsLiked, "numberOfLikes": self.numberOfPostLikes] as [String : Any]
                        self.registerPostIntoDataBase(userUid, values: values as [String : AnyObject])
                        
                    }, withCancel: nil)
                }
                
            })
                      //self.pickedImageView.image = UIImage(named: "ig")
            self.tabBarController?.selectedIndex = 0
            self.navigationController?.popToRootViewController(animated: true)  
       }
    }
    
    func registerPostIntoDataBase(_ uid: String, values: [String: Any]) {
        let ref = FIRDatabase.database().reference(fromURL: "https://instaclone-abf88.firebaseio.com/")
        let PostsReference = ref.child("posts").childByAutoId()
        
        PostsReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print("Error saving user: \(err ?? "" as! Error)")
                return
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isStatusBarHidden = true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickedImageView.image = selectedImage
    }
    
    func backAction(){
        dismiss(animated: true, completion: nil)
    }

    func handleShare(){
        //sharePost()
    }
    func handleBack(){
        
    }

}
