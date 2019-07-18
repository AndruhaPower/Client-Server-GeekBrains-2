//
//  CustomSearchGroupCell.swift
//  L1_GBVk
//
//  Created by Andrew on 12/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

class CustomSearchGroupCell: UITableViewCell {
    
    static var reuseId: String = "CustomSearchGroupCell"
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupAvatarImage: AvatarImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
