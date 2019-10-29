//
//  Photo.swift
//  L1_GBVk
//
//  Created by Andrew on 10/07/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import ObjectMapper

class VKPhotoResponse: Mappable {

    var response: VKPhotoResponseInternal? = nil
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.response <- map["response"]
    }
}

class VKPhotoResponseInternal: Mappable {
    
    var items: [Photo] = []
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.items <- map["items"]
    }
}

class Photo: Mappable {
    
    var photoURL: String = ""
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.photoURL <- map["sizes.3.url"]
    }
}
