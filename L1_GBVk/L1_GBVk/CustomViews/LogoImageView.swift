//
//  LogoImageView.swift
//  L1_GBVk
//
//  Created by Andrew on 15/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

final class LogoImageView: UIView {
    
    private var imageView: UIImageView!
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageView = UIImageView(frame: bounds)
        self.imageView.clipsToBounds = true
        self.addSubview(imageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = frame.height / 3
        self.imageView.layer.cornerRadius = frame.height / 3
        self.imageView.clipsToBounds = true
    }
}

