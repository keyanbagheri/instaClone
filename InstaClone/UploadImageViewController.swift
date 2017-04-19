//
//  UploadImageViewController.swift
//  InstaClone
//
//  Created by Arkadijs Makarenko on 18/04/2017.
//  Copyright © 2017 teamHearts. All rights reserved.
//
import UIKit
import Firebase

class UploadImageViewController: UIViewController {
    let picker = UIImagePickerController()
    var userName = ""
    var userProfilePicture = ""
    var postIsLiked = false
    var numberOfPostLikes = 0
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let currentStoryboard = UIStoryboard (name: "Main", bundle: Bundle.main)
        let initController = currentStoryboard.instantiateViewController(withIdentifier: "NewPostTableViewController")
        navigationController?.pushViewController(initController, animated: true)
    }
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var libraryButtonTapped: UIButton!{
        didSet {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choosePostImage))
            libraryButtonTapped.isUserInteractionEnabled = true
            libraryButtonTapped.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    @IBAction func cameraPhotoMaker(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.camera
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            present(picker,animated: true,completion: nil)
        } else {
            noCameraOnDevice()
        }
    }
    
    func noCameraOnDevice(){
        let alertVC = UIAlertController(title: "No Camera",message: "Device without camera",preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC,animated: true, completion: nil)
    }
    
    @IBAction func uploadButtonTapped(_ sender: Any) {
        sharePost()
    }
    
    func sharePost(){
        if photoImageView.image == UIImage(named: "ig"){
        }else{
            //  guard let userUid = FIRAuth.auth()?.currentUser?.uid else {return}
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("postsImages").child("\(imageName).jpeg")
            
            let image = self.photoImageView.image
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
                            guard let username = user.name,
                            let pic = user.profileImageUrl else {return}
                            self.userName = username
                            self.userProfilePicture = pic
                            
                        }

                        let values = ["userId": userUid, "postImageUrl": photoImageUrl,"userName":self.userName, "userProfileImageURL":self.userProfilePicture, "likeImageIsTapped": self.postIsLiked, "numberOfLikes": self.numberOfPostLikes] as [String : Any]
                        self.registerPostIntoDataBase(userUid, values: values as [String : Any])
                        
                    }, withCancel: nil)
                }
            })
            self.photoImageView.image = UIImage(named: "ig")
            self.tabBarController?.selectedIndex = 0
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleImage()
    }
    func handleImage(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(choosePostImage))
        photoImageView.isUserInteractionEnabled = true
        photoImageView.addGestureRecognizer(tap)
    }
    func choosePostImage(){
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
}//end vc
extension UploadImageViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("User canceled out of picker")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage
        {
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage
        {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker
        {
            photoImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
}
