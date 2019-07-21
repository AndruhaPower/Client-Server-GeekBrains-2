//
//  GroupModel.swift
//  L1_GBVk
//
//  Created by Andrew on 24/05/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit

struct GroupModel {
    var name: String
    var rating: Int
    var avatarPath: String = ""
}

extension GroupModel: Equatable {
    static func == (lhs: GroupModel, rhs: GroupModel) -> Bool {
        return lhs.name == rhs.name || lhs.avatarPath == rhs.avatarPath
    }
}

