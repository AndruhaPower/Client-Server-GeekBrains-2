//
//  AvatarImageView.swift
//  L1_GBVk
//
//  Created by Andrew on 30/05/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

class AvatarImageView: UIView {
    
    private var imageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView = UIImageView(frame: bounds)
        imageView.clipsToBounds = true
        addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2
        imageView.layer.cornerRadius = frame.height / 2
        imageView.clipsToBounds = true
        
    }

}
