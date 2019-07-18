//
//  Group.swift
//  L1_GBVk
//
//  Created by Andrew on 10/07/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import ObjectMapper


class VKGroupResponse: Mappable {
    
    var response: VKGroupResponseInternal? = nil
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.response <- map["response"]
    }
}

class VKGroupResponseInternal: Mappable {
    
    var items: [Group] = []
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.items <- map["items"]
    }
}

class Group: Mappable, Equatable {
    var id: Int = 0
    var photo: String = ""
    var name: String = ""
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.photo <- map["photo_50"]
        self.name <- map["name"]
    }
    
    static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.name == rhs.name || lhs.photo == rhs.photo
    }
}
