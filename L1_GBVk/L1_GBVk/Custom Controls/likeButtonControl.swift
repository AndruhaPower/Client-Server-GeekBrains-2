//
//  likeButton.swift
//  L1_GBVk
//
//  Created by Andrew on 31/05/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit
import Foundation


@IBDesignable final class LikeButtonControl: UIControl {
    private var stackView: UIStackView!
    var likeButton = HeartButton()
    let likesLabel = UILabel()
    var likesCount: Int = 0
    var liked: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        self.likeButton.isUserInteractionEnabled = false
        self.likesLabel.text = "\(likesCount)"
        self.likesLabel.textColor = UIColor.darkGray

        self.stackView = UIStackView(arrangedSubviews: [likeButton, likesLabel])
        self.addSubview(stackView)
        self.stackView.distribution = .fillEqually
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.stackView.frame = bounds
    }
    
    func incrementLikesCount() {
        self.likesCount += 1
        self.updateLikesCount(likes: likesCount)
    }
    
    func decrementLikesCount() {
        self.likesCount -= 1
        self.updateLikesCount(likes: likesCount)
    }
    
    func updateLikesCount(likes: Int) {
        self.likesCount = likes
        self.likesLabel.text = "\(likesCount)"
    }
    
    func like() {
        if !self.liked {
            self.likeButton.liked = true
            self.likeButton.setNeedsDisplay()
            self.incrementLikesCount()
            self.liked = true
        } else {
            self.likeButton.liked = false
            self.likeButton.setNeedsDisplay()
            self.decrementLikesCount()
            self.liked = false
        }
    }
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(onTap(_:)))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        return recognizer
    }()
    
    @objc func onTap(_ sender: HeartButton) {
        self.like()
        self.animateLikeButton()
    }
    
    
    func animateLikeButton() {
        let animation = CASpringAnimation(keyPath: "transform.scale")
        animation.fromValue = 0
        animation.toValue = 1
        animation.stiffness = 200
        animation.mass = 1
        animation.duration = 1
        animation.beginTime = CACurrentMediaTime()
        animation.fillMode = CAMediaTimingFillMode.backwards
        
        self.likeButton.layer.add(animation, forKey: nil)
    }
    
}
