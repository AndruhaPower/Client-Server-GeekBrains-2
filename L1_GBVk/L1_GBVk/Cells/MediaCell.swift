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
    }
    
    private func configureUI() {
        
        self.newsImage.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.newsImage)

        self.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            self.newsImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0),
            self.newsImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            self.newsImage.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            self.newsImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0)
            ]
        )
        
    }
}
