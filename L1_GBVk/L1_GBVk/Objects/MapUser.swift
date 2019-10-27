//
//  MapUser.swift
//  L1_GBVk
//
//  Created by Andrew on 29/07/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import ObjectMapper
import Foundation

class VKUserResponse: Mappable {
    
    var response: VKUserResponseInternal? = nil
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.response <- map["response"]
    }
}

class VKUserResponseInternal {
    
    var id: Int = 0
    var photo: String = ""
    var firstName : String = ""
    var lastName : String = ""
    var name: String {
        get {
            return firstName+" "+lastName
        }
    }
    
    var description: String {
        return (String(self.id)+", "+self.name+","+self.photo)
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.photo <- map["photo_50"]
        self.firstName <- map["first_name"]
        self.lastName <- map["last_name"]
    }
}
