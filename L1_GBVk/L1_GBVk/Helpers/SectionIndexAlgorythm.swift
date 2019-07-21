//
//  SectionIndexAlgorythm.swift
//  L1_GBVk
//
//  Created by Andrew on 12/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import Foundation

class SectionIndexManager {
    
    static func getOrderedIndexArray(array: [RFriend]) -> [Character] {
        var indexArray: [Character] = []
        var indexSet = Set<Character>()
        for item in array {
            let firstLetter = item.name[0]
            indexSet.insert(firstLetter)
        }
        for char in indexSet{
            indexArray.append(char)
        }
        indexArray.sort()
        return indexArray
    }
    
    static func getFriendIndexDictionary(array: [RFriend]) -> [Character: [RFriend]] {
        var friendIndexDictionary: [Character: [RFriend]] = [:]
        
        for item in array {
            let firstLetter = item.name[0]
            if (friendIndexDictionary.keys.contains(firstLetter)) {
                friendIndexDictionary[firstLetter]?.append(item)
            } else {
                friendIndexDictionary[firstLetter] = [item]
            }
        }
        return friendIndexDictionary
    }
    
    //MARK: - For Groups
    
    static func getOrderedIndexArray(array: [Group]) -> [Character] {
        var indexArray: [Character] = []
        var indexSet = Set<Character>()
        for item in array {
            let firstLetter = item.name[0]
            indexSet.insert(firstLetter)
        }
        for char in indexSet{
            indexArray.append(char)
        }
        indexArray.sort()
        return indexArray
    }
    
    static func getGroupIndexDictionary(array: [Group]) -> [Character: [Group]] {
        var groupIndexDictionary: [Character: [Group]] = [:]
        
        for item in array {
            let firstLetter = item.name[0]
            if (groupIndexDictionary.keys.contains(firstLetter)) {
                groupIndexDictionary[firstLetter]?.append(item)
            } else {
                groupIndexDictionary[firstLetter] = [item]
            }
        }
        return groupIndexDictionary
    }
}

