//
//  ViewsControl.swift
//  L1_GBVk
//
//  Created by Andrew on 15/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//
import UIKit
import Foundation

@IBDesignable final class ViewsControl: UIControl {
    private var stackView: UIStackView!
    private var viewsIcon = UIImage(named: "eye")
    private var viewsIconView = UIImageView()
    private let viewsLabel = UILabel()
    var viewsCount: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView() {
        self.viewsIconView.image = viewsIcon
        self.viewsIconView.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        self.viewsLabel.text = "\(viewsCount)"
        self.viewsLabel.textColor = UIColor.darkGray
        self.stackView = UIStackView(arrangedSubviews: [viewsIconView, viewsLabel])
        
        self.addSubview(stackView)
        self.stackView.distribution = .fillEqually
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.stackView.frame = bounds
    }
    
    func incrementViewsCount() {
        self.viewsCount += 1
        self.updateViewsCount(comments: self.viewsCount)
    }
    
    func decrementViewsCount() {
        self.viewsCount -= 1
        self.updateViewsCount(comments: self.viewsCount)
    }
    
    func updateViewsCount(comments: Int) {
        self.viewsCount = comments
        self.viewsLabel.text = "\(self.viewsCount)"
    }
}

