//
//  AvatarShadowView.swift
//  L1_GBVk
//
//  Created by Andrew on 29/05/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

class AvatarShadowView: UIView {
    
    @IBInspectable var shadowColor: UIColor = .black
    @IBInspectable var shadowOpacity: Float = 1
    @IBInspectable var shadowRadius: CGFloat = 15
    @IBInspectable var shadowOffset: CGSize = .zero
    
    
    var cornerRadius: CGFloat {
        return frame.width/2
    }
    
    func sharedInit() {
        setCornerRadius(value: cornerRadius)
        setShadow()
    }
    
    func setCornerRadius(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    func setShadow() {
        layer.shadowRadius = shadowRadius
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = shadowOffset
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
}
