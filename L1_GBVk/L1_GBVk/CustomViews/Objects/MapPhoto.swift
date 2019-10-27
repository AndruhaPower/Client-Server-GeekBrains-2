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
    var photoWidth: CGFloat = 0
    var photoHeight: CGFloat = 0
    var ratio: CGFloat {
        guard self.photoWidth != 0 && self.photoHeight != 0 else { return 100 }
        return CGFloat(self.photoWidth)/CGFloat(self.photoHeight)
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.photoURL <- map["sizes.3.url"]
        self.photoWidth <- map["sizes.3.width"]
        self.photoHeight <- map["sizes.3.height"]
    }
}
