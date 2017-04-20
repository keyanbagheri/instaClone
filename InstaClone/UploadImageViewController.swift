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
        let initController = currentStoryboard.instantiateViewController(withIdentifier: "NewPostTableViewController") as? NewPostTableViewController
        if let selectedImage = photoImageView.image {
            initController?.selectedImage = selectedImage
        }
        navigationController?.pushViewController(initController!, animated: true)
    }
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    @IBAction func libraryToolbarTapped(_ sender: Any){
        choosePostImage()
    }

    @IBAction func photoToolbarTapped(_ sender: Any) {
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
        let alertVC = UIAlertController(title: "No Camera", message: "Device without camera", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        photoImageView.image = UIImage(named: "ig")
        handleImage()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    func handleCancel(){
        self.tabBarController?.selectedIndex = 0
    
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
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
}

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
