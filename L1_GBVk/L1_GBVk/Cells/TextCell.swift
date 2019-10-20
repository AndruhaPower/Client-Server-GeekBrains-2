//
//  Text Cell.swift
//  L1_GBVk
//
//  Created by Andrew on 16/10/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell {
    
    static var reuseIdentifier: String = "TextCellReuseId"
    @IBOutlet weak var newsText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
