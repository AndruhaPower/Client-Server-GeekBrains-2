//
//  CustomFriendsCell.swift
//  L1_GBVk
//
//  Created by Andrew on 10/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

class CustomFriendsCell: UITableViewCell {
    
    static var reuseId: String = "CustomFriendCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: AvatarImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
