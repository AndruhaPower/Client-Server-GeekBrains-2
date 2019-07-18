//
//  CustomPresentModalAnimator.swift
//  L1_GBVk
//
//  Created by Andrew on 24/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

final class CustomPresentModalAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.8
    var presenting = true
    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        //let fromView = transitionContext.view(forKey: .from)!
        let toView = transitionContext.view(forKey: .to)!
        
        containerView.addSubview(toView)
        toView.alpha = 0.0
        
        UIView.animate(withDuration: duration,
                       animations: {
                        toView.alpha = 1.0
        },
                       completion: { _ in
                        transitionContext.completeTransition(true)
        }
        )
    }
}
