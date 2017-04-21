//
//  TimeLineTableViewCell.swift
//  InstaClone
//
//  Created by Arkadijs Makarenko on 17/04/2017.
//  Copyright © 2017 teamHearts. All rights reserved.
//

import UIKit

protocol MyCellProtocol {
    func didTapOnComment (_ post: Photo)
}
class TimeLineTableViewCell: UITableViewCell {
    var delegate : MyCellProtocol? = nil
    var photo : Photo?
    static let cellIdentifier = "TimeLineTableViewCell"
    static let cellNib = UINib(nibName: TimeLineTableViewCell.cellIdentifier, bundle: Bundle.main)
    
    @IBOutlet weak var profileImageView: UIImageView!{
        didSet{
            profileImageView.layer.cornerRadius = profileImageView.frame.width/2
            profileImageView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var captionTextView: UITextView!
    
    @IBOutlet weak var likesCounter: UILabel!
    

    var isLiked  = false
    var likeButtonClicked = false
    var numberOfLikes = 0

    var postUserId : String?
    var postId: String?
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        print("like button tapped!!!")
        likeButtonClicked = true
        handleLike()
    }
    
    func handleLike () {
        print(likeButtonClicked)
        if isLiked && !likeButtonClicked { return }
        
        isLiked = !isLiked
        print(isLiked)
        if isLiked {
            likeButton.setImage(#imageLiteral(resourceName: "love"), for: .normal)
        } else {
            likeButton.setImage(#imageLiteral(resourceName: "like"), for: .normal)
        }
        
        likeButtonClicked = false
    }
    
    @IBAction func commentButtonTapped(_ sender: Any) {
        // using notificaiton
        
        print(postId!)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue:"OpenComments"), object: nil, userInfo: ["postID":postId!])

    }
    

    func handleImage(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleLike))
        tap.numberOfTapsRequired = 2
        postImageView.addGestureRecognizer(tap)
        postImageView.isUserInteractionEnabled = true
    }
    
    func handleGoToProfile(){
        let profileView = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        userNameLabel.addGestureRecognizer(profileView)
        userNameLabel.isUserInteractionEnabled = true
    }
    
    func labelTapped(_ sender: UITapGestureRecognizer) {
        // using notificaiton
        
        print(postUserId!)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue:"OpenProfile"), object: nil, userInfo: ["profileID":postUserId!])
        
    }
    
    var postIdentifier : String?
    var numberOflikes = Int()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    
    
}

protocol CustomCellDelegate {
    func openProfile(_ profileID: String)
}

