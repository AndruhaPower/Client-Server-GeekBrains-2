//
//  FullScreenCollectionView.swift
//  L1_GBVk
//
//  Created by Andrew on 24/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

class FullScreenCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var friendsImageView: UIImageView!
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        //addGestureRecognizer(tapGestureRecognizer)
        friendsImageView.contentMode = .scaleAspectFit
        
    }
}
