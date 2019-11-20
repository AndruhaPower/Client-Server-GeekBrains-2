//
//  AvatarCell.swift
//  L1_GBVk
//
//  Created by Andrew on 22/05/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

final class AvatarCell: UICollectionViewCell {
    
    var indexPath: IndexPath?
    static let reuseIdentifier = "AvatarCell"
    @IBOutlet weak var likeButton: LikeButtonControl!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.avatarImageView.image = nil
    }
}
