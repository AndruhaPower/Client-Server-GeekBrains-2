//
//  Text Cell.swift
//  L1_GBVk
//
//  Created by Andrew on 16/10/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

protocol TextCellDelegate: class {
    func textCellTapped(at cell: TextCell)
}

class TextCell: UITableViewCell {
    
    static var reuseIdentifier: String = "TextCellReuseId"
    @IBOutlet weak var newsText: UILabel!
    public weak var delegate: TextCellDelegate?
    public var isExpanded: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.addGestureRecognizer(tapGR)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    @objc func tapped() {
        delegate?.textCellTapped(at: self)
    }
}
