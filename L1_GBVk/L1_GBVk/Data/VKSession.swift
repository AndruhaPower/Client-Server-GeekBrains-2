//
//  Session.swift
//  L1_GBVk
//
//  Created by Andrew on 01/07/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper

class VKSession {
    
    static let shared = VKSession()
    
    var token: String?
    var userid: Int = 0
    
    private init () {}
}

