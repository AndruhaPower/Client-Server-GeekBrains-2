//
//  ViewsControl.swift
//  L1_GBVk
//
//  Created by Andrew on 15/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//
import UIKit
import Foundation

@IBDesignable class ViewsControl: UIControl {
    private var stackView: UIStackView!
    private var viewsIcon = UIImage(named: "viewsicon.png")
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
        viewsIconView.image = viewsIcon
        viewsIconView.frame = CGRect(x: 0, y: 0, width: 22, height: 22)
        viewsLabel.text = "\(viewsCount)"
        viewsLabel.textColor = UIColor.darkGray
        setupConstraints()
        
        //MARK: to debug ViewsControl position uncomment two lines below
        //    viewsIconView.layer.borderWidth = 1.0
        //    viewsLabel.layer.borderWidth = 1.0
        
        stackView = UIStackView(arrangedSubviews: [viewsIconView, viewsLabel])
        
        self.addSubview(stackView)
        stackView.distribution = .fillEqually
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    func setupConstraints() {
        viewsLabel.heightAnchor.constraint(equalTo: viewsIconView.heightAnchor, multiplier: 1)
    }
    
    func incrementViewsCount() {
        viewsCount += 1
        updateViewsCount(comments: viewsCount)
    }
    
    func decrementViewsCount() {
        viewsCount -= 1
        updateViewsCount(comments: viewsCount)
    }
    
    func updateViewsCount(comments: Int) {
        viewsCount = comments
        viewsLabel.text = "\(viewsCount)"
    }
    
    lazy var tapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self,
                                                action: #selector(onTap(_:)))
        recognizer.numberOfTapsRequired = 1
        recognizer.numberOfTouchesRequired = 1
        return recognizer
    }()
    
    @objc func onTap(_ sender: UIStackView) {
        incrementViewsCount()
    }
}

