//
//  ImageTapAnimation.swift
//  L1_GBVk
//
//  Created by Andrew on 22/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit
class ImageTapAnimations {
    
    static func animateImageTap(imageView: AvatarImageView) {
        let animationDuration: TimeInterval = 0.5
        
        UIView.animateKeyframes(withDuration: animationDuration, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: animationDuration) {
                let animationIn = CASpringAnimation(keyPath: "transform.scale")
                animationIn.fromValue = 1
                animationIn.toValue = 0.8
                animationIn.stiffness = 100
                animationIn.mass = 0.5
                animationIn.duration = 0.5
                animationIn.beginTime = CACurrentMediaTime()
                animationIn.fillMode = CAMediaTimingFillMode.backwards
                imageView.layer.add(animationIn, forKey: nil)
            }
        }) { (isFinished) in
            
            let animationOut = CASpringAnimation(keyPath: "transform.scale")
            animationOut.fromValue = 0.8
            animationOut.toValue = 1
            animationOut.stiffness = 200
            animationOut.mass = 1
            animationOut.duration = 1
            animationOut.beginTime = CACurrentMediaTime()
            animationOut.fillMode = CAMediaTimingFillMode.both
            
            imageView.layer.add(animationOut, forKey: nil)
        }
    }
}
