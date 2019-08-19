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
import FirebaseFirestore
import Firebase


class VKServices {
    
    static let custom: Session = {
        let config = URLSessionConfiguration.default
        config.headers = .default
        config.timeoutIntervalForRequest = 20
        let manager = Alamofire.Session(configuration: config)
        return manager
    }()

    // ПОЛУЧАЕМ ДРУЗЕЙ
    
    public func getFriends( completion: @escaping (Bool)->()) {
        
        let url = VKConstants.friends
        
        let params: Parameters = [
            "access_token": KeychainWrapper.standard.string(forKey: "VKToken")!,
            "order": "name",
            "fields": "photo_50,city",
            "v": VKConstants.vAPI
        ]
        print(params["access_token"]) // удалить перед сдачей
        
        VKServices.custom.request(url, method: .get, parameters: params).responseObject(completionHandler: { (vkfriendsResponse: DataResponse<VKFriendResponse>) in
            
            let result = vkfriendsResponse.result
            switch result {
            case .success(let val):
                let items = val.response?.items
                RealmManager.friendsManager(friends: items!)
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        })
    }
    
    // ПОЛУЧАЕМ СВОИ ГРУППЫ
    
    public func getGroups() {
        
        let url = VKConstants.groups
        
        let params: Parameters = [
            "access_token" : KeychainWrapper.standard.string(forKey: "VKToken")!,
            "extended" : "1",
            "v" : VKConstants.vAPI
        ]
        
        VKServices.custom.request(url, method: .get, parameters: params).responseObject(completionHandler: {
            (vkgroupResponse: DataResponse<VKGroupResponse>) in
            
            let result = vkgroupResponse.result
            switch result {
            case .success(let val):
                let items = val.response?.items
                RealmManager.groupsManager(groups: items!)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    // ПОЛУЧАЕМ ГРУППЫ ДЛЯ ПОИСКА
    
    public func getSearchGroups() {
        
        let url = VKConstants.groupsSearch
        
        let params: Parameters = [
            "access_token" : KeychainWrapper.standard.string(forKey: "VKToken")!,
            "extended" : "1",
            "q" : "iOS",
            "v" : VKConstants.vAPI
        ]
        
        VKServices.custom.request(url, method: .get, parameters: params).responseObject(completionHandler: { (vkgroupResponse: DataResponse<VKGroupResponse>) in
            
            let result = vkgroupResponse.result
            switch result {
            case .success(let val):
                guard let items = val.response?.items else { return }
                RealmManager.groupsManager(groups: items)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    // ПОЛУЧАЕМ НОВОСТИ
    
    public func getNews(count: Int, completion: @escaping ([Feed]?)->()) {
        let url = VKConstants.newsFeed
        
        let params: Parameters = [
        
            "filters" : "post",
            "count" : String(count),
            "access_token" : KeychainWrapper.standard.string(forKey: "VKToken")!,
            "v" : VKConstants.vAPI,
            "source_ids" : "groups"
        ]
        
        VKServices.custom.request(url, method: .get, parameters: params).responseObject(completionHandler: { (vkfeedResponse: DataResponse<VKFeedResponse>) in
            
            let result = vkfeedResponse.result
            switch result {
            case.success(let val):
                guard let items = val.response?.items else { return }
                completion(items)
            case.failure(let error):
                print(error)
                completion(nil)
            }
        })
    }
    
    
    // ПОЛУЧАЕМ ССЫЛКИ НА ФОТКИ
    
    public func getPhotos(id: Int, completion: @escaping (Bool)->()) {
        
        let url = VKConstants.photosURL
        
        let params: Parameters = [
            
            "owner_id" : String(id),
            "extended" : "0",
            "skip_hidden" : "1",
            "access_token" : KeychainWrapper.standard.string(forKey: "VKToken")!,
            "v" : VKConstants.vAPI
        ]
        
        VKServices.custom.request(url, method: .get, parameters: params).responseObject(completionHandler: { (vkphotoresponse: DataResponse<VKPhotoResponse>) in
            
            let result = vkphotoresponse.result
            switch result {
            case .success(let val):
                guard let items = val.response?.items else { return }
                RealmManager.photosManager(photos: items, id: id)
                completion(true)
            case .failure(let error):
                print(error)
                completion(false)
            }
        })
    }
}
