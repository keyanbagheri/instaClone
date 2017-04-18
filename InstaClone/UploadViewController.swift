//
//  UploadViewController.swift
//  InstaClone
//
//  Created by Arkadijs Makarenko on 18/04/2017.
//  Copyright © 2017 teamHearts. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class UploadViewController: UIViewController {
    
    let picker = UIImagePickerController()
    
    @IBOutlet weak var uploadImageView: UIImageView!
        
//        didSet {
//            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(enableImagePicker))
//            uploadImageView.isUserInteractionEnabled = true
//            uploadImageView.addGestureRecognizer(tapGestureRecognizer)
//        }
    
    @IBOutlet weak var captionTextView: UITextView!{
        didSet{
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(removePlaceholderText))
            captionTextView.isUserInteractionEnabled = true
            captionTextView.addGestureRecognizer(tapGestureRecognizer)
            
        }
    }
    @IBOutlet weak var libraryPhotoPicker: UIButton!{
        didSet {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(enableImagePicker))
            libraryPhotoPicker.isUserInteractionEnabled = true
            libraryPhotoPicker.addGestureRecognizer(tapGestureRecognizer)
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
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Device without camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(
            alertVC,
            animated: true,
            completion: nil)
    }
    
    
    func enableImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func removePlaceholderText() {
        if captionTextView.text == "#instaClone" {
            captionTextView.text = ""
            captionTextView.isUserInteractionEnabled = true
            captionTextView.font = captionTextView.font?.withSize(12)
            captionTextView.textColor = UIColor.black
        } else {
            return
        }
    }
    
//    var ref: FIRDatabaseReference!
//    var currentUser : FIRUser? = FIRAuth.auth()?.currentUser
//    var currentUserID : String = ""
//    var currentUserEmail : String = ""
//    var profileUsername : String = ""
//    var profileImageURL : String = ""
//    
//    var uploadImageURL : String = ""
//    var newPost : Photo?
//    var personalPosts : [Photo] = []
//    var lastID = 0
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("uploaded_images").child("\(imageName).jpg")
        
        if let uploadImage = self.uploadImageView.image, let uploadData = UIImageJPEGRepresentation(uploadImage, 0.1) {
            
            storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil {
                    print(error!)
                    return
                }
                self.uploadImageView.image = UIImage(named: ("ig"))
                self.tabBarController?.selectedIndex = 0
                if let uploadImageUrl = metadata?.downloadURL()?.absoluteString {
                    let values = ["profileImageUrl": uploadImageUrl]
                    //self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //enableImagePicker()
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectorImageView)))
    }
//    func setCurrentUser() {
//        ref = FIRDatabase.database().reference()
//        // Do any additional setup after loading the view, typically from a nib.
//        
//        if let id = currentUser?.uid,
//            let email = currentUser?.email {
//            print(id)
//            currentUserID = id
//            currentUserEmail = email
//        }
//    }
//    func createTimeStamp() -> String {
//        
//        let currentDate = NSDate()
//        let dateFormatter:DateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM-dd HH:mm"
//        let timeCreated = dateFormatter.string(from: currentDate as Date)
//        
//        return timeCreated
//        
//    }
}


extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleSelectorImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            uploadImageView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
}
