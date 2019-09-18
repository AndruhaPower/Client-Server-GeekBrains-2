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
    var indexPath: IndexPath?
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var groupAvatarImage: AvatarImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        self.groupAvatarImage.image = nil
    }
}
