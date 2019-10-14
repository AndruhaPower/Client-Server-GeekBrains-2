//
//  CustomNewsCell.swift
//  L1_GBVk
//
//  Created by Andrew on 15/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import Foundation
import UIKit


class CustomNewsCell: UITableViewCell {
    
    static var reuseId: String = "CustomNewsCell"
    var indexPath: IndexPath?
    @IBOutlet weak var newsText: UILabel!
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var userphoto: AvatarImageView!
    @IBOutlet weak var stackView: ControlsStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        self.stackView.likes.likesCount = 0
        self.stackView.comments.commentsCount = 0
        self.stackView.shares.sharesCount = 0
        self.userphoto.image = UIImage(named: "noimage")
        self.newsImage.image = nil
    }
}

class ControlsStackView: UIStackView {
    
    @IBOutlet weak var likes: LikeButtonControl!
    @IBOutlet weak var comments: CommentControl!
    @IBOutlet weak var shares: ShareControl!    
}
