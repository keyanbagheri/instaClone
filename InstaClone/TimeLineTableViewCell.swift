//
//  TimeLineTableViewCell.swift
//  InstaClone
//
//  Created by Arkadijs Makarenko on 17/04/2017.
//  Copyright © 2017 teamHearts. All rights reserved.
//

import UIKit

class TimeLineTableViewCell: UITableViewCell {

    static let cellIdentifier = "TimeLineTableViewCell"
    static let cellNib = UINib(nibName: TimeLineTableViewCell.cellIdentifier, bundle: Bundle.main)
    
    @IBOutlet weak var profileImageView: UIImageView!{
        didSet{
            profileImageView.layer.cornerRadius = profileImageView.frame.width/2
            profileImageView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var postImageiew: UIImageView!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var captionTextView: UITextView!
    
    @IBOutlet weak var likesCounter: UILabel!
    
    var isLiked  = false
    var likeButtonClicked = false
    var numberOfLikes = 0
    
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
    }
    
    func handleImage(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleLike))
        tap.numberOfTapsRequired = 2
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
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
