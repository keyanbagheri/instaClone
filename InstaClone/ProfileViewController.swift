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
    
//    REMOVE THE FOLLOWING CLASS LINES WHEN USER.SWIFT IS MADE
    class User {
        var id: String
        
        init () {
            id = ""
        }
    }
    var currentProfileUser : User = User()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ref = FIRDatabase.database().reference()
        
        dummyPhotoList = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17"]

        
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

