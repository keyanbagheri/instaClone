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
    var selectedPostID = ""
    var numberOfPostLikes = 0
    var imageURL = ""
    
    var currentUser = User.currentUser
    var profileImageUrl : String = ""
    var comments = [Comment]()
    var ref = FIRDatabase.database().reference()
    
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
        ref = FIRDatabase.database().reference().child("posts").childByAutoId()
        sharePost()
    }
    
    func shareCaption(){
        let childRef = ref.child("comments").childByAutoId()
        let values: [String: Any] = ["text": captionTextField.text! as String, "userName": currentUser.name!, "userId": currentUser.id!, "timestamp": "\(NSNumber(value: Int(Date().timeIntervalSince1970)))", "userProfileImageUrl": currentUser.profileImageUrl! as String]
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            //let recipientUserCommentsRef = FIRDatabase.database().reference().child("user-comments").child(toId)
            //recipientUserCommentsRef.updateChildValues([commentId: 1])
        }
    }
    
    func sharePost(){
        if pickedImageView.image == UIImage(named: "ig"){
        }else{
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
                    self.imageURL = photoImageUrl
                    let values = ["userId": self.currentUser.id!, "postImageUrl": photoImageUrl,"userName":self.currentUser.userName, "userProfileImageURL":self.currentUser.profileImageUrl] as [String : Any]
                    self.registerPostIntoDataBase(self.currentUser.id!, values: values as [String : AnyObject])
                    self.addToUsersPhotos()
                    self.shareCaption()
                }
            })
                      //self.pickedImageView.image = UIImage(named: "ig")
            self.tabBarController?.selectedIndex = 0
            self.navigationController?.popToRootViewController(animated: true)  
       }
    }
    
    func registerPostIntoDataBase(_ uid: String, values: [String: Any]) {
        ref.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print("Error saving user: \(err ?? "" as! Error)")
                return
            }
        })
    }
    
    func addToUsersPhotos() {
        let userRef = FIRDatabase.database().reference().child("users").child(currentUser.id!).child("photos").child(ref.key)
        let values: [String: String] = ["imageURL": imageURL as String]
        
        userRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            //let recipientUserCommentsRef = FIRDatabase.database().reference().child("user-comments").child(toId)
            //recipientUserCommentsRef.updateChildValues([commentId: 1])
        }
        
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
