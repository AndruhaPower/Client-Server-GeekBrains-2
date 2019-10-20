//
//  File.swift
//  L1_GBVk
//
//  Created by Andrew on 20/10/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import UIKit


class NewsViewModelFabric {
    
    private var vkServices = VKServices()
    
    private static func setupNewsData(news: [Feed], groups: [Groups]) -> ([NewsViewModel]) {
        var newsViewModel: [NewsViewModel] = []
        for post in news {
            for group in groups {
                if group.id == -(post.source_id) {
                    newsViewModel.append(NewsViewModel(news: post, name: group.name, avatarPhotoUrl: group.photoUrl))
                }
            }
        }
        return newsViewModel
    }
    
    func fetch(completion: @escaping ([NewsViewModel])->()) {
        self.vkServices.getNews(count: 50) { resultFeed, resultGroups in
            guard let feed = resultFeed,
                let groups = resultGroups
                else { return }
            completion(NewsViewModelFabric.setupNewsData(news: feed, groups: groups))
            }
        }
    }

struct NewsViewModel {
    
    var commentCount: Int
    var likesCount: Int
    var repostCount: Int
    var viewsCount: Int
    var photoUrl: String
    var text: String
    var ratio: CGFloat
    var name: String
    var avatarPhotoUrl: String
    
    init(news: Feed, name: String, avatarPhotoUrl: String) {
        self.commentCount = news.commentCount
        self.likesCount = news.likesCount
        self.repostCount = news.repostCount
        self.viewsCount = news.viewsCount
        self.photoUrl = news.photoUrl
        self.text = news.text
        self.ratio = news.ratio
        self.name = name
        self.avatarPhotoUrl = avatarPhotoUrl
    }
}
