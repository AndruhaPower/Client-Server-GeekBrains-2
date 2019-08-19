//
//  Map Feed.swift
//  L1_GBVk
//
//  Created by Andrew on 19/08/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import ObjectMapper

class VKFeedResponse: Mappable {
    
    var response: VKFeedResponseInternal? = nil
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.response <- map["response"]
    }
}

class VKFeedResponseInternal: Mappable {
    
    var items: [Feed] = []
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.items <- map["items"]
    }
}

class Feed: Mappable, CustomStringConvertible {
    
    var commentCount: Int = 0
    var likesCount: Int = 0
    var repostCount: Int = 0
    // var name: String = ""
    // var isMember: Int = 0
    // var id: Int = 0
    var photoUrl: String = ""
    var text: String = ""
    
    var description: String {
        return (String("ФОТО: "+self.photoUrl+" ТЕКСТ НОВОСТИ: \n\(self.text)"))
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.commentCount <- map["comments.count"]
        self.repostCount <- map["reposts.count"]
        self.likesCount <- map["likes.count"]
        self.photoUrl <- map["attachments.0.photo.sizes.3.url"]
        self.text <- map["text"]
    }
}
