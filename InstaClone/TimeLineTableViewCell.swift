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
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var postImageiew: UIImageView!
    
    
    @IBOutlet weak var captionTextView: UITextView!
    
    @IBOutlet weak var likesCounter: UILabel!
    
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func commentButtonTapped(_ sender: Any) {
    }
    
    
    var postIdentifier : String?
    var numberOflikes = Int()
    var likeIsTapped  = false
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
