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
    var attachments: [Attachments] = []
    var text: String = ""
    var date: Double = 0
    
    var description: String {
        return "ТЕКСТ НОВОСТИ: \n\(self.text)"+"LIKES: \n"+String(self.likesCount)+"  COMMENTS: \n"+String(self.commentCount)+" REPOSTS: \n"+String(self.repostCount)+" VIEWS: "+String(self.viewsCount)+" \n Width Hight Ratio: "
    }
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        self.commentCount <- map["comments.count"]
        self.repostCount <- map["reposts.count"]
        self.likesCount <- map["likes.count"]
        self.viewsCount <- map["views.count"]
        self.source_id <- map["source_id"]
        self.attachments <- map["attachments"]
        self.date <- map["date"]
        self.text <- map["text"]

    }
}

class Attachments: Mappable, CustomStringConvertible {
    
    var type: String = ""
    var url: String = ""
    var width: Int = 0
    var height: Int = 0
    var ratio: CGFloat {
        guard self.width != 0 && self.height != 0 else { return 100 }
        return CGFloat(self.width)/CGFloat(self.height)
    }
    
    var description: String {
        return self.type + self.url
    }
    
    required init?(map: Map) { }
    func mapping(map: Map) {
        self.type <- map["type"]
        switch self.type {
        case "photo":
            self.url <- map["photo.sizes.3.url"]
            self.width <- map["photo.sizes.3.width"]
            self.height <- map["photo.sizes.3.height"]
        case "video":
            break
        case "doc":
            break
        default:
            break
        }
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
