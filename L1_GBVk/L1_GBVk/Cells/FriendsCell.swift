//
//  FriendsCell.swift
//  L1_GBVk
//
//  Created by Andrew on 22/05/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

class FriendsCell: UITableViewCell {

    static let reuseIdentifier = "FriendsCell"
    
    @IBOutlet weak var friendNameLabel: UILabel!
    @IBOutlet weak var friendAvatar: AvatarImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
