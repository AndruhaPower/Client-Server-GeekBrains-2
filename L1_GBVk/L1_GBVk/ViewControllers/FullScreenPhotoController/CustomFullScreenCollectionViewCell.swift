//
//  CustomFullScreenCollectionViewCell.swift
//  L1_GBVk
//
//  Created by Andrew on 23/10/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

final class CustomFullScreenCollectionViewCell: UICollectionViewCell {
    
    static var reuseIdentifier: String = "CustomFullScreenCollectionViewCell"
    var imageView = UIImageView()
    var indexPath: IndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        self.imageView.image = nil
    }
    
    
    func configureUI() {
        self.addSubview(self.imageView)
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .darkGray
        
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
            ])
    }
}

