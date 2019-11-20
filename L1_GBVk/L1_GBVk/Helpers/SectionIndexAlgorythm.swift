//
//  SectionIndexAlgorythm.swift
//  L1_GBVk
//
//  Created by Andrew on 12/06/2019.
//  Copyright © 2019 Andrew. All rights reserved.
//

import Foundation

final class SectionIndexManager {
    
    static func getOrderedIndexArray(array: [RealmIndexable]) -> [Character] {
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
    
    static func getFriendIndexDictionary(array: [RealmIndexable]) -> [Character: [RealmIndexable]] {
        var friendIndexDictionary: [Character: [RealmIndexable]] = [:]
        
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
}

