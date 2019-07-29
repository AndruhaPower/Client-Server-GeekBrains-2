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
    
    // ПОЛУЧАЕМ ПОЛЬЗОВАТЕЛЕЙ
    
    
    
    public func getUsers() {
        
        let url = VKConstants.users
        
        let params: Parameters = [
            "user_ids" : String(VKSession.shared.userid),
            "fields" : "id,photo_50,first_name,last_name",
            "access_token" : KeychainWrapper.standard.string(forKey: "VKToken")!,
            "v" : VKConstants.vAPI
        ]
        
        VKServices.custom.request(url, method: .get, parameters: params).responseObject(completionHandler: { (vkuserResponse: DataResponse<VKUserResponse>) in
        
            let result  = vkuserResponse.result
            switch result {
            case .success(let val):
                let db = Firestore.firestore()
                var ref: DocumentReference? = nil
                ref = db.collection("user").document("\(val.response?.id)")
                ref?.setData([
                    "name" : val.response?.name,
                    "id" : val.response?.id,
                    "photo" : val.response?.photo
                ]) { error in
                    if let err = error {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
            case .failure(let error):
                print(error)
            }

        })
    }

    // ПОЛУЧАЕМ ДРУЗЕЙ
    
    public func getFriends() {
        
        let url = VKConstants.friends
        
        let params: Parameters = [
            "access_token": KeychainWrapper.standard.string(forKey: "VKToken")!,
            "order": "name",
            "fields": "photo_50,city",
            "v": VKConstants.vAPI
        ]
        
        VKServices.custom.request(url, method: .get, parameters: params).responseObject(completionHandler: { (vkfriendsResponse: DataResponse<VKFriendResponse>) in
            
            let result = vkfriendsResponse.result
            switch result {
            case .success(let val):
                let items = val.response?.items
                RealmManager.friendsManager(friends: items!)
            case .failure(let error):
                print(error)
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
                let items = val.response?.items
                RealmManager.groupsManager(groups: items!)
            case .failure(let error):
                print(error)
            }
        })
    }
    
    // ПОЛУЧАЕМ ССЫЛКИ НА ФОТКИ
    
    public func getPhotos(id: Int, _ completionHandler:@escaping (_ photos:[Photo]?)->()) {
        
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
                var photos: [Photo] = []
                guard let items = val.response?.items else { return }
                for photo in items {
                    if photo.photoURL != "" {
                        photos.append(photo)
                    }
                }
                completionHandler(photos)
            case .failure(let error):
                print(error)
            }
        })
    }
}



