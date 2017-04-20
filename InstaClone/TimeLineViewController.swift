//
//  TimeLineViewController.swift
//  InstaClone
//
//  Created by Arkadijs Makarenko on 18/04/2017.
//  Copyright © 2017 teamHearts. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class TimeLineViewController: UIViewController {

    var filteredPhotoFeed: [Photo] = []
    var photos = [Photo]()
    var uid = FIRAuth.auth()?.currentUser?.uid
    var currentUser : FIRUser? = FIRAuth.auth()?.currentUser
    var postsUsersIds = [String].self
    var following = [String]()
    var lastPostID : Int = 0
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.register(TimeLineTableViewCell.cellNib, forCellReuseIdentifier: TimeLineTableViewCell.cellIdentifier)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: Notification.Name(rawValue:"OpenProfile"), object: nil)
        
        getCurrentUserInfo()
        fetchUsers()
        fetchPhoto()
    }
    func fetchUsers() {
        FIRDatabase.database().reference().child("users").child(uid!).child("following").observe(.value, with: { (snapshot) in
            
            //   if let dictionary = snapshot.value as? [String: AnyObject] {
            //                 let user = User(dictionary: dictionary)
            //                 user.id = (snapshot.value as? NSDictionary)?.allKeys as? [String] ?? []
            //               self.following.append(user.id!)
            
            let allId = (snapshot.value as? NSDictionary)?.allKeys as? [String] ?? []
            self.following.append(contentsOf: allId)
            print("FollowersUserIdsArray: ",self.following)
            
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
            
            // }
            
        }, withCancel: nil)
    }
    func fetchPhoto() {
        FIRDatabase.database().reference().child("posts").observe(.childAdded, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let photo = Photo(dictionary: dictionary)
                photo.id = snapshot.key
                
                self.photos.append(photo)
                //self.postsUsersIds.append(photo.userId!)????????????????????????????????????
                print("postUserIdsArray: ",self.postsUsersIds)
                
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                    
                })
                
            }
            
        }, withCancel: nil)
    }
    
    func getCurrentUserInfo () {
        FIRDatabase.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot) in
            print("Value : " , snapshot)
            
            let dictionary = snapshot.value as? [String: Any]
            
            User.currentUser.updateUser(withAnId: (snapshot.key), anEmail: (dictionary?["email"])! as! String, aName: (dictionary?["name"])! as! String, aScreenName: (dictionary?["userName"])! as! String, aDesc: (dictionary?["desc"])! as! String, aProfileImageURL: (dictionary?["profileImageUrl"])! as! String)
        })
        
    }
}



extension TimeLineViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 550
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TimeLineTableViewCell.cellIdentifier, for: indexPath) as? TimeLineTableViewCell else {  return UITableViewCell()}
        
        
        let currentPost = photos[indexPath.row]
        let postImageUrl = currentPost.postImageUrl
        let userProfileImageUrl = currentPost.userProfileImageUrl
        
        cell.delegate = self
        cell.photo = currentPost
        
        cell.userNameLabel.text = currentPost.userName
        cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: userProfileImageUrl!)
        cell.postImageView.loadImageUsingCacheWithUrlString(urlString: postImageUrl!)
        
        //cell.captionTextView.text = photo.caption
        //cell.callTapGesture()
        cell.postIdentifier = currentPost.id
        cell.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 300)
        //cell.numberOflikes = post.numberOfLikes
        
        //        cell.observeLikesOnPost(post.id!)
        //        print("postid in CellforRow   ",post.id!)
        
        //3 conform
        //cell.delegate = self
        //cell.updatepostLikesNumber(post.id!)
        cell.postUserId = currentPost.userId
        cell.handleImage()
        cell.handleGoToProfile()
        return cell
    }
    internal func likeImageIstapped() -> Bool {
        return true
    }
    // navigate to profile screen
    func displayProfileScreen(){}
    
    func handleNotification(_ notification: NSNotification){
        print(notification)
        if let profileID = notification.userInfo?["profileID"] as? String {
            // ADD CODE TO GO TO EDIT PROFILE VIEW
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            guard let controller = storyboard .instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else { return }
            controller.profileUserID = profileID
            navigationController?.pushViewController(controller, animated: true)
        }
        
    }
}

extension TimeLineViewController : MyCellProtocol {
    
    func didTapOnComment(_ post: Photo) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let controller = storyboard .instantiateViewController(withIdentifier: "CommentsViewController") as?
            CommentsViewController else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
