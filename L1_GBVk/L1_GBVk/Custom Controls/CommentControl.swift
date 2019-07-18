//
//  CommentControl.swift
//  L1_GBVk
//
//  Created by Andrew on 15/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CommentControl: UIControl {
    private var stackView: UIStackView!
    private var commentIcon = UIImage(named: "commenticon.png")
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
        commentIconView.image = commentIcon
        commentIconView.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        commentsLabel.text = "\(commentsCount)"
        commentsLabel.textColor = UIColor.darkGray
        setupConstraints()
        
        //MARK: to debug CommentControl position uncomment two lines below
        //    commentIconView.layer.borderWidth = 1.0
        //    commentsLabel.layer.borderWidth = 1.0
        
        stackView = UIStackView(arrangedSubviews: [commentIconView, commentsLabel])
        
        self.addSubview(stackView)
        stackView.distribution = .fillEqually
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    func setupConstraints() {
        commentsLabel.heightAnchor.constraint(equalTo: commentIconView.heightAnchor, multiplier: 1)
    }
    
    func incrementCommentsCount() {
        commentsCount += 1
        updateCommentsCount(comments: commentsCount)
    }
    
    func decrementCommentsCount() {
        commentsCount -= 1
        updateCommentsCount(comments: commentsCount)
    }
    
    func updateCommentsCount(comments: Int) {
        commentsCount = comments
        commentsLabel.text = "\(commentsCount)"
    }
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(onTap(_:)))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        return recognizer
    }()
    
    @objc func onTap(_ sender: UIStackView) {
        incrementCommentsCount()
    }
}
