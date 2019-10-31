//
//  ShareControl.swift
//  L1_GBVk
//
//  Created by Andrew on 15/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class ShareControl: UIControl {
    private var stackView: UIStackView!
    private var shareIcon = UIImage(named: "share")
    private var shareIconView = UIImageView()
    private let sharesLabel = UILabel()
    var sharesCount: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        self.shareIconView.image = self.shareIcon
        self.shareIconView.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        self.sharesLabel.text = "\(self.sharesCount)"
        self.sharesLabel.textColor = UIColor.darkGray
        self.stackView = UIStackView(arrangedSubviews: [self.shareIconView, self.sharesLabel])
        
        self.addSubview(self.stackView)
        self.stackView.distribution = .fillEqually
        addGestureRecognizer(self.tapGestureRecognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.stackView.frame = bounds
    }
    
    func incrementSharesCount() {
        self.sharesCount += 1
        self.updateSharesCount(comments: self.sharesCount)
    }
    
    func decrementSharesCount() {
        self.sharesCount -= 1
        self.updateSharesCount(comments: self.sharesCount)
    }
    
    func updateSharesCount(comments: Int) {
        self.sharesCount = comments
        self.sharesLabel.text = "\(self.sharesCount)"
    }
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(onTap(_:)))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        return recognizer
    }()
    
    @objc func onTap(_ sender: UIStackView) {
        self.incrementSharesCount()
    }
}
