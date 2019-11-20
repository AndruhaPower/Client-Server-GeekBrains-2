//
//  CommentControl.swift
//  L1_GBVk
//
//  Created by Andrew on 15/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable final class CommentControl: UIControl {
    private var stackView: UIStackView!
    private var commentIcon = UIImage(named: "comment")
    private var commentIconView = UIImageView()
    private let commentsLabel = UILabel()
    var commentsCount: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        self.commentIconView.image = self.commentIcon
        self.commentIconView.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        self.commentsLabel.text = "\(self.commentsCount)"
        self.commentsLabel.textColor = UIColor.darkGray

        self.stackView = UIStackView(arrangedSubviews: [self.commentIconView, self.commentsLabel])
        
        self.addSubview(self.stackView)
        self.stackView.distribution = .fillEqually
        addGestureRecognizer(self.tapGestureRecognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.stackView.frame = bounds
    }
    
    func incrementCommentsCount() {
        self.commentsCount += 1
        self.updateCommentsCount(comments: self.commentsCount)
    }
    
    func decrementCommentsCount() {
        self.commentsCount -= 1
        self.updateCommentsCount(comments: self.commentsCount)
    }
    
    func updateCommentsCount(comments: Int) {
        self.commentsCount = comments
        self.commentsLabel.text = "\(self.commentsCount)"
    }
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(onTap(_:)))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        return recognizer
    }()
    
    @objc func onTap(_ sender: UIStackView) {
        self.incrementCommentsCount()
    }
}
