//
//  AvatarShadowView.swift
//  L1_GBVk
//
//  Created by Andrew on 29/05/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

final class AvatarShadowView: UIView {
    
    @IBInspectable var shadowColor: UIColor = .black
    @IBInspectable var shadowOpacity: Float = 1
    @IBInspectable var shadowRadius: CGFloat = 15
    @IBInspectable var shadowOffset: CGSize = .zero
    
    var cornerRadius: CGFloat {
        return frame.width/2
    }
    
    func sharedInit() {
        self.setCornerRadius(value: cornerRadius)
        self.setShadow()
    }
    
    func setCornerRadius(value: CGFloat) {
        self.layer.cornerRadius = value
    }
    
    func setShadow() {
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowOffset = shadowOffset
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        self.sharedInit()
    }
}
