//
//  GroupTableViewCell.swift
//  L1_GBVk
//
//  Created by Andrew on 22/05/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    static var reuseIdentifier = "GroupCell"
    @IBOutlet weak var GroupLabel: UILabel!
    @IBOutlet weak var groupAvatar: AvatarImageView!
    @IBOutlet weak var SearchLabel: UILabel!
    @IBOutlet weak var searchGroupAvatar: AvatarImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
