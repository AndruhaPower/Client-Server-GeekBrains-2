//
//  HeartButtonView.swift
//  L1_GBVk
//
//  Created by Andrew on 15/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class HeartButton: UIButton {
    
    @IBInspectable var filled: Bool = true
    @IBInspectable var strokeWidth: CGFloat = 2.0
    @IBInspectable var strokeColor: UIColor = UIColor.gray
    
    var liked: Bool = false
    
    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath(heartHeight: self.bounds.height)
        
        if !liked {
            strokeColor = UIColor.gray
            self.strokeColor.setStroke()
            self.filled = false
        } else {
            strokeColor = UIColor.red
            self.tintColor = UIColor.red
            self.strokeColor.setStroke()
            self.tintColor.setFill()
            bezierPath.fill()
        }
        bezierPath.lineWidth = self.strokeWidth
        bezierPath.stroke()
    }
}
