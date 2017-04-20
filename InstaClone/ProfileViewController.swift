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
    
    @IBOutlet weak var wholeView: UIView!
    
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
    var ref: FIRDatabaseReference!
    var currentUser : FIRUser? = FIRAuth.auth()?.currentUser
    var profileUserID = "3DqqiWKvSzPf2Lwy7WllKxOcOB83"
    var isFollowed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        wholeView.isHidden = true
        
        ref = FIRDatabase.database().reference()
        listenToFirebase()
        checkIfUserIsLoggedIn()
        
        // make the profile picture have a round radius
        userImageView.layer.masksToBounds = false
        userImageView.layer.cornerRadius = userImageView.frame.height/2
        userImageView.clipsToBounds = true
        
        // change the border color of button
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0).cgColor

    }
    func checkIfUserIsLoggedIn() {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {
            //for some reason uid = nil
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                self.setupNavBarWithUser(user)
            }
        }, withCancel: nil)
    }
    
    func setupNavBarWithUser(_ user: User) {
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)

        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        containerView.addSubview(profileImageView)
        
        //ios 9 constraint anchors
        //need x,y,width,height anchors
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        //need x,y,width,height anchors
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        self.navigationItem.titleView = titleView
        
    }
    func handleLogout() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let currentStoryboard = UIStoryboard (name: "Auth", bundle: Bundle.main)
        let initController = currentStoryboard.instantiateViewController(withIdentifier: "LogInViewController")
        present(initController, animated: true, completion: nil)
    }
 /*-------------------------------------------*/
    
    func followUser() {
        // ADD CODE TO FOLLOW A USER
        if isFollowed {
            ref.child("users").child(profileUserID).child("followers").child((currentUser?.uid)!).removeValue()
            ref.child("users").child((currentUser?.uid)!).child("following").child(profileUserID).removeValue()
            
            self.button.setTitle("Follow", for: .normal)
        } else {
    
            let following : [String : String] = [profileUserID : "true"]
            
            let follower : [String : String] = [currentUser!.uid : "true"]
            
            ref.child("users").child(profileUserID).child("followers").updateChildValues(follower)
            ref.child("users").child((currentUser?.uid)!).child("following").updateChildValues(following)
            
            self.button.setTitle("Following", for: .normal)
        }
        isFollowed = !isFollowed
    }
    
    func editProfile() {
        // ADD CODE TO GO TO EDIT PROFILE VIEW
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let controller = storyboard .instantiateViewController(withIdentifier: "EditProfileTableViewController") as?
            EditProfileTableViewController else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func listenToFirebase() {
        ref.child("users").child(profileUserID).observe(.value, with: { (snapshot) in
            print("Value : " , snapshot)
            
            let dictionary = snapshot.value as? [String: Any]
            
            let currentProfileUser = User(withAnId: (snapshot.key), anEmail: (dictionary?["email"])! as! String, aName: (dictionary?["name"])! as! String, aScreenName: (dictionary?["userName"])! as! String, aDesc: (dictionary?["desc"])! as! String, aProfileImageURL: (dictionary?["profileImageUrl"])! as! String)
        
            self.ref.child("users").child((self.currentUser?.uid)!).child("following").child(self.profileUserID).observe(.value, with: { (instance) in
                print(instance)
                
                if instance.exists() {
                    self.isFollowed = true
                    self.button.setTitle("Following", for: .normal)
                }
            })
            // load screen name in nav bar
            self.navigationItem.title = currentProfileUser.userName
            
            // load the profile image
            self.userImageView.loadImageUsingCacheWithUrlString(urlString: currentProfileUser.profileImageUrl!)
            
            // load the user name
            self.userNameLabel.text = currentProfileUser.name
            
            // load the user description
            self.userDescLabel.text = currentProfileUser.desc
            
            // check if user profile is the same as current user
            // if same button text = "Edit Profile"
            // if not button text = "Follow"
            if currentProfileUser.id != self.currentUser?.uid {
                self.button.addTarget(self, action: #selector(self.followUser), for: .touchUpInside)
            } else {
                self.button.setTitle("Edit Profile", for: .normal)
                self.button.addTarget(self, action: #selector(self.editProfile), for: .touchUpInside)
            }
            self.wholeView.isHidden = false

        })
        
        ref.child("users").child(profileUserID).child("photos").observe(.value, with: { (snapshot) in
            print("Value : " , snapshot)
            
            let photos = snapshot.value as? [String: Any]
            
            for (k, v) in photos! {
                
//                if let dictionary = v as? [String: String] {
//        
//                    // fix when uploading photos has been changed with actual data (not just imageURL)
//                    let newPhoto = Photo(withAnId: k, aUserID: "", aUserName: "", aLocation: "", anImagePostURL: dictionary["imageURL"]!, anImageProfileURL: "", aCaption: "",  aTimeStamp: "")
//                    self.photoList.append(newPhoto)
//                }
            }
            self.imageCollectionView.reloadData()
        })
    }
}

extension ProfileViewController : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell else {return UICollectionViewCell()}
        
//        cell.imageView.loadImageUsingCacheWithUrlString(urlString: photoList[indexPath.row].imagePostURL)
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

