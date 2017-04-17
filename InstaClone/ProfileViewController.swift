//
//  ProfileViewController.swift
//  
//
//  Created by bitbender on 4/15/17.
//
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class ProfileViewController: UIViewController {
    @IBOutlet weak var postsCountLabel: UILabel!
    
    @IBOutlet weak var followersCountLabel: UILabel!
  
    @IBOutlet weak var followingCountLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userDescLabel: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var imageCollectionView: UICollectionView! {
        didSet {
            imageCollectionView.dataSource = self
            imageCollectionView.delegate = self
            
        }
    }
    
    var photoList : [Photo] = []
    var dummyPhotoList : [String] = []
    
    var ref: FIRDatabaseReference!
    
//    var currentUser : FIRUser? = FIRAuth.auth()?.currentUser
    
    var currentProfileUser : User = User()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ref = FIRDatabase.database().reference()
        
        dummyPhotoList = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17"]
        
        currentProfileUser = User(withAnId: "3DqqiWKvSzPf2Lwy7WllKxOcOB83", anEmail: "ard@123.com", aName: "ard", aScreenName: "ard1090", aDesc: "I am Ard and I love taking photos for my 18 instagram accounts", aProfileImageURL: "https://firebasestorage.googleapis.com/v0/b/instaclone-abf88.appspot.com/o/15.jpg?alt=media&token=cdef7623-cbc9-4cca-b717-58d118c92553")
        
        // load screen name in nav bar
        navigationItem.title = currentProfileUser.screenName
        
        // make the profile picture have a round radius
        userImageView.layer.masksToBounds = false
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        userImageView.clipsToBounds = true
        // load the profile image
        userImageView.loadImageUsingCacheWithUrlString(urlString: currentProfileUser.profileImageURL)

        // load the user name
        userNameLabel.text = currentProfileUser.name
        
        // load the user description
        userDescLabel.text = currentProfileUser.desc
        
        // change the border color of button
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor
        
        // check if user profile is the same as current user
        // if same button text = "Edit Profile"
        // if not button text = "Follow"
//        if currentProfileUser.id != currentUser.id {
//            button.setTitle("Follow", for: .normal)
//        }
        
        
//        listenToFirebase()
    }
    
    func listenToFirebase() {
        
        ref.child("users").child(currentProfileUser.id).child("uploads").observe(.value, with: { (snapshot) in
            print("Value : " , snapshot)
        })
        
        

        
    }

}

extension ProfileViewController : UICollectionViewDataSource {


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dummyPhotoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {return UICollectionViewCell()}
        
        let messageURL = "https://firebasestorage.googleapis.com/v0/b/instaclone-abf88.appspot.com/o/\(dummyPhotoList[indexPath.item]).jpg?alt=media&token=2a97f974-cfc9-41b1-8f34-d86ddac9afba"
        cell.imageView.loadImageUsingCacheWithUrlString(urlString: messageURL)
        return cell
    }
}


extension ProfileViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellsAcross: CGFloat = 3
        let dim = CGFloat(collectionView.bounds.width / cellsAcross)
        return CGSize(width: dim, height: dim)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
      {
        return 0
    }
}

