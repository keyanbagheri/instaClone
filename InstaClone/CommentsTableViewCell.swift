//
//  CommentsTableViewCell.swift
//  InstaClone
//
//  Created by ardMac on 18/04/2017.
//  Copyright © 2017 teamHearts. All rights reserved.
//

import UIKit

class CommentsTableViewCell: UITableViewCell {
    static let cellIdentifier = "CommentsTableViewCell"
    static let cellNib = UINib(nibName: CommentsTableViewCell.cellIdentifier, bundle: Bundle.main)

    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.layer.cornerRadius = (26/2)
            profileImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var commentsTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }

    
}
