//
//  CustomFriendsCell.swift
//  L1_GBVk
//
//  Created by Andrew on 10/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

final class CustomFriendsCell: UITableViewCell {
    
    static var reuseId: String = "CustomFriendCell"
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: AvatarImageView!
    var indexPath: IndexPath?

    override func prepareForReuse() {
        super.prepareForReuse()
        self.avatarImage.image = UIImage(named: "noimage")
        self.nameLabel.text = "UNKNOWN"
    }
}
