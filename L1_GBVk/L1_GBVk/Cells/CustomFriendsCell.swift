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
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.avatarImage.image = UIImage(named: "noimage")
        self.nameLabel.text = "UNKNOWN"
    }
}
