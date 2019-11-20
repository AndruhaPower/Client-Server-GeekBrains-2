//
//  VKServices.swift
//  L1_GBVk
//
//  Created by Andrew on 07/07/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//
import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftKeychainWrapper
import RealmSwift


final class VKServices {
    
    static let custom: Session = {
        let config = URLSessionConfiguration.default
        config.headers = .default
        config.timeoutIntervalForRequest = 20
        let manager = Alamofire.Session(configuration: config)
        return manager
    }()

    public func getFriends(completion: @escaping (Bool)->()) {
        
        let url = VKConstants.friends
        
        let params: Parameters = [
            "access_token": KeychainWrapper.standard.string(forKey: "VKToken")!,
            "order": "name",
            "fields": "photo_50,city",
            "v": VKConstants.vAPI
        ]

        
        VKServices.custom.request(url, method: .get, parameters: params).responseObject(completionHandler: { (vkfriendsResponse: DataResponse<VKFriendResponse, AFError>) in
            
            let result = vkfriendsResponse.result
            switch result {
            case .success(let val):
                guard let items = val.response?.items else { return }
                RealmManager.friendsManager(friends: items)
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        })
    }

    public func getGroups(completion: @escaping (Bool)->()) {
        
        let url = VKConstants.groups
        
        let params: Parameters = [
            "access_token" : KeychainWrapper.standard.string(forKey: "VKToken")!,
            "extended" : "1",
            "v" : VKConstants.vAPI
        ]
        
        VKServices.custom.request(url, method: .get, parameters: params).responseObject(completionHandler: {
            (vkgroupResponse: DataResponse<VKGroupResponse, AFError>) in
            
            let result = vkgroupResponse.result
            switch result {
            case .success(let val):
                guard let items = val.response?.items else { return }
                RealmManager.groupsManager(groups: items)
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        })
    }
    
    public func getSearchGroups(completion: @escaping (Bool)->()) {
        
        let url = VKConstants.groupsSearch
        
        let params: Parameters = [
            "access_token" : KeychainWrapper.standard.string(forKey: "VKToken")!,
            "extended" : "1",
            "q" : "iOS",
            "v" : VKConstants.vAPI
        ]
        
        VKServices.custom.request(url, method: .get, parameters: params).responseObject(completionHandler: { (vkgroupResponse: DataResponse<VKGroupResponse, AFError>) in
            
            let result = vkgroupResponse.result
            switch result {
            case .success(let val):
                guard let items = val.response?.items else { return }
                RealmManager.groupsManager(groups: items)
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        })
    }
    
    public func getNews(startTime: Double? = nil, startFrom: String? = "", completion: @escaping ([NewsViewModel]?, String?)->()){
        let url = VKConstants.newsFeed
        
        var params: Parameters = [
        
            "filters" : "post",
            "access_token" : KeychainWrapper.standard.string(forKey: "VKToken")!,
            "v" : VKConstants.vAPI,
            "source_ids" : "groups"
        ]
        if let startTime = startTime {
            params["start_time"] = startTime
        }
        if let startFrom = startFrom {
            params["start_from"] = startFrom
        }
        
        VKServices.custom.request(url, method: .get, parameters: params).responseObject(completionHandler: { (vkfeedResponse: DataResponse<VKFeedResponse, AFError>) in
            
            let result = vkfeedResponse.result
            switch result {
            case.success(let val):
                guard let items = val.response?.items,
                      let groups = val.response?.groups,
                      let nextFrom = val.response?.nextFrom else
                { return }
                let news = NewsViewModelFabric.setupNewsData(news: items, groups: groups)
                DispatchQueue.main.async {
                    completion(news, nextFrom)
                }
            case.failure(let error):
                print(error)
                DispatchQueue.main.async {
                    completion(nil, nil)
                }
            }
        })
    }

    public func getPhotos(id: Int, completion: @escaping ([Photo]?) -> ()) {
        
        let url = VKConstants.photosURL
        
        let params: Parameters = [
            
            "owner_id" : String(id),
            "album_id" : "profile",
            "photo_sizes" : "1",
            "extended" : "0",
            "skip_hidden" : "1",
            "access_token" : KeychainWrapper.standard.string(forKey: "VKToken")!,
            "v" : VKConstants.vAPI
        ]
        
        VKServices.custom.request(url, method: .get, parameters: params).responseObject(completionHandler: { (vkphotoresponse: DataResponse<VKPhotoResponse, AFError>) in
            
            let result = vkphotoresponse.result
            switch result {
            case .success(let val):
                guard let items = val.response?.items  else
                { return }
                completion(items)
            case .failure(let error):
                print(error)
            }
        })
    }
}
