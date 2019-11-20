//
//  CustomGroupCell.swift
//  L1_GBVk
//
//  Created by Andrew on 12/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

class CustomGroupCell: UITableViewCell {
    
    static var reuseId: String = "CustomGroupCell"
    open var indexPath: IndexPath?
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupAvatarImage: AvatarImageView!

    override func prepareForReuse() {
        self.groupAvatarImage.image = UIImage(named: "community_template")
    }
}
