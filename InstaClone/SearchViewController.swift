//
//  SearchViewController.swift
//  InstaClone
//
//  Created by bitbender on 4/18/17.
//  Copyright © 2017 teamHearts. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class SearchViewController: UIViewController {
    
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var imageCollectionView: UICollectionView! {
        didSet {
            imageCollectionView.dataSource = self
            imageCollectionView.delegate = self
            
        }
    }
    
    var ref: FIRDatabaseReference!
    
    var currentUser : FIRUser? = FIRAuth.auth()?.currentUser
    
    var photoList : [Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        topImageView.loadImageUsingCacheWithUrlString(urlString: "https://cdn.pixabay.com/photo/2015/02/18/11/50/mountain-landscape-640617_1280.jpg")
        ref = FIRDatabase.database().reference()
        listenToFirebase()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func listenToFirebase() {
        ref.child("users").observe(.value, with: { (snapshot) in
            print("Value : " , snapshot)
            let users = snapshot.value as? [String: Any]
            
            for (k, v) in users! {
                
                if let info = v as? [String: Any] {
                    
                    for (ke, val) in info {
                        
                        if ke == "photos" {
                            if let photos = val as? [String: Any] {
                                
                                for (key, value) in photos {
                                    
                                    if let photo = value as? [String: String] {
                                        //fix when uploading photos has been changed with actual data (not just imageURL)
                                        let newPhoto = Photo(withAnId: key, aUserID: "", aUserName: "", aLocation: "", aPostImageURL: photo["imageURL"]!, aUserProfileImageURL: "",  aTimeStamp: "")
                                        self.photoList.append(newPhoto)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            self.imageCollectionView.reloadData()
            let height = self.imageCollectionView.collectionViewLayout.collectionViewContentSize.height
            self.collectionViewHeightConstraint.constant = height
        })
    }
}

extension SearchViewController : UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {return UICollectionViewCell()}
        
        cell.imageView.loadImageUsingCacheWithUrlString(urlString: photoList[indexPath.row].postImageUrl!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        //        guard let controller = storyboard .instantiateViewController(withIdentifier: "PhotoShowController") as?
        //            PhotoShowController else { return }
        //
        //        controller.currentPhoto = photoList[indexPath.row]
        //
        //        navigationController?.pushViewController(controller, animated: true)
    }
}


extension SearchViewController : UICollectionViewDelegateFlowLayout {
    
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
