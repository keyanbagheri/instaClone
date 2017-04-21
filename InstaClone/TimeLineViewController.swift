//
//  TimeLineViewController.swift
//  InstaClone
//
//  Created by Arkadijs Makarenko on 18/04/2017.
//  Copyright © 2017 teamHearts. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class TimeLineViewController: UIViewController {

    var filteredPhotoFeed: [Photo] = []
    var photos = [Photo]()
    var uid : String?
    var currentUser = User.currentUser
    var postsUsersIds = [String].self
    var following = [String]()
    var lastPostID : Int = 0
    var ref: FIRDatabaseReference!
    
    @IBAction func cameraItemButtonTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 2
    }
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            
            tableView.register(TimeLineTableViewCell.cellNib, forCellReuseIdentifier: TimeLineTableViewCell.cellIdentifier)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToProfile(_:)), name: Notification.Name(rawValue:"OpenProfile"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToComments(_:)), name: Notification.Name(rawValue:"OpenComments"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(like(_:)), name: Notification.Name(rawValue:"Like"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(unlike(_:)), name: Notification.Name(rawValue:"Unlike"), object: nil)
        
        uid = FIRAuth.auth()?.currentUser?.uid
        ref = FIRDatabase.database().reference()
        getCurrentUserInfo()
        fetchUsers()
        fetchPhoto()
    }
    func fetchUsers() {
        ref.child("users").child(uid!).child("following").observe(.value, with: { (snapshot) in
            
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
        ref.child("posts").observe(.childAdded, with: { (snapshot) in
            
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
        
        ref.child("users").child(uid!).observe(.value, with: { (snapshot) in
            print("Value : " , snapshot)
            
            let dictionary = snapshot.value as? [String: Any]
            
            User.currentUser.updateUser(withAnId: (snapshot.key), anEmail: (dictionary?["email"])! as! String, aName: (dictionary?["name"])! as! String, aScreenName: (dictionary?["userName"])! as! String, aDesc: (dictionary?["desc"])! as! String, aProfileImageURL: (dictionary?["profileImageUrl"])! as! String)
        })
        
    }

}
 


extension TimeLineViewController: UITableViewDelegate, UITableViewDataSource {

    
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
        
        ref.child("posts").child("\(currentPost.id)").child("likes").observe(.value, with: { (snapshot) in
            
            if snapshot.exists() {
                let likes = snapshot.value as? [String: Any]
                
                cell.numberOfLikes = likes!.count
                cell.likesCounter.text = "\(cell.numberOfLikes)"
            } else {
                cell.likesCounter.text = "0"
            }
            
        })
        
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
        cell.postId = currentPost.id
        cell.handleImage()
        cell.handleGoToProfile()
        return cell
    }
    internal func likeImageIstapped() -> Bool {
        return true
    }
    // navigate to profile screen
    func displayProfileScreen(){}
    
    func goToProfile(_ notification: NSNotification){
        print(notification)
        if let profileID = notification.userInfo?["profileID"] as? String {
            // ADD CODE TO GO TO EDIT PROFILE VIEW
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            guard let controller = storyboard .instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else { return }
            controller.profileUserID = profileID
            navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    func goToComments(_ notification: NSNotification){
        print(notification)
        if let postId = notification.userInfo?["postID"] as? String {
            // ADD CODE TO GO TO Comments
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            guard let controller = storyboard .instantiateViewController(withIdentifier: "CommentsViewController") as?
                CommentsViewController else { return }
            controller.selectedPostID = postId
            navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    func like(_ notification: NSNotification){
        print(notification)
        if let postId = notification.userInfo?["postID"] as? String {
            // ADD Like TO GO TO post likes
            let childRef = ref.child("posts").child("\(postId)").child("likes").child("\(uid!)")
            let values: [String: Any] = ["userId": uid! as String]
            
            childRef.updateChildValues(values) { (error, ref) in
                if error != nil {
                    print(error!)
                    return
                }
                //let recipientUserCommentsRef = FIRDatabase.database().reference().child("user-comments").child(toId)
                //recipientUserCommentsRef.updateChildValues([commentId: 1])
            }
        }
        
    }
    func unlike(_ notification: NSNotification){
        print(notification)
        if let postId = notification.userInfo?["postID"] as? String {
            // remove like from posts likes
            ref.child("posts").child("\(postId)").child("\(uid!)").removeValue()
        }
        
    }
}

