//
//  MediaCell.swift
//  L1_GBVk
//
//  Created by Andrew on 16/10/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

class MediaCell: UITableViewCell {
    
    var newsImage = UIImageView()
    var indexPath: IndexPath?
//    var ratio: CGFloat = 0  {
//        didSet {
//            guard self.ratio != 0 else { return }
//            self.updateContentSize()
//        }
//    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.newsImage.image = nil
//        self.imageWidthConstraint?.constant = 0
//        self.imageHeightConstraint?.constant = 0
    }
    
    private func configureUI() {
        
        self.newsImage.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.newsImage)
//
//
//        self.imageWidthConstraint = self.newsImage.widthAnchor.constraint(equalToConstant: self.frame.size.width)
//        self.imageHeightConstraint = self.newsImage.heightAnchor.constraint(equalToConstant: 0)
//
//        self.imageHeightConstraint?.isActive = true
//        self.imageWidthConstraint?.isActive = true
//
        self.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            self.newsImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.newsImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            self.newsImage.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            self.newsImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0)
            ]
        )
        
    }
    
//    func updateContentSize() {
//        let width = self.frame.size.width
//        self.imageWidthConstraint?.constant = width
//        self.imageHeightConstraint?.constant = width / self.ratio
//    }
}
