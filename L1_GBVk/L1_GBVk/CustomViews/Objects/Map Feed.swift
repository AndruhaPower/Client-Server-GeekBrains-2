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
    var groups: [Groups] = []
    var startFrom: String = ""
    var nextFrom: String = ""
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.items <- map["items"]
        self.groups <- map["groups"]
        self.nextFrom <- map["next_from"]
    }
}

class Feed: Mappable, CustomStringConvertible {
    
    var commentCount: Int = 0
    var likesCount: Int = 0
    var repostCount: Int = 0
    var viewsCount: Int = 0
    var source_id: Int = 0
    var photoUrl: String = ""
    var text: String = ""
    var photoWidth: Int = 0
    var photoHeight: Int = 0
    var date: Double = 0
    var ratio: CGFloat {
            guard self.photoWidth != 0 && self.photoHeight != 0 else { return 100 }
        return CGFloat(self.photoWidth)/CGFloat(self.photoHeight)
    }
    
    var description: String {
        return (String("ФОТО: "+self.photoUrl+" ТЕКСТ НОВОСТИ: \n\(self.text)"+" LIKES: \n"+String(self.likesCount)+"  COMMENTS: \n"+String(self.commentCount)+" REPOSTS: \n"+String(self.repostCount)+" VIEWS: "+String(self.viewsCount)+" \n Width Hight Ratio: "+String(self.photoWidth)+" & "+String(self.photoHeight)))
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.commentCount <- map["comments.count"]
        self.repostCount <- map["reposts.count"]
        self.likesCount <- map["likes.count"]
        self.viewsCount <- map["views.count"]
        self.source_id <- map["source_id"]
        self.date <- map["date"]
        self.photoUrl <- map["attachments.0.photo.sizes.3.url"]
        self.photoWidth <- map["attachments.0.photo.sizes.3.width"]
        self.photoHeight <- map["attachments.0.photo.sizes.3.height"]
        self.text <- map["text"]

    }
}

class Groups: Mappable, CustomStringConvertible {
    
    var id: Int = 0
    var name: String = ""
    var photoUrl: String = ""
    
    var description: String {
        return(String("Имя группы: "+self.name+", id группы: "+String(self.id)+" \n фотография группы: "+self.photoUrl))
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.id <- map["id"]
        self.name <- map["name"]
        self.photoUrl <- map["photo_100"]
    }
}
