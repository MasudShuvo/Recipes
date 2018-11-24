//
//  Utility.swift
//  Recipes
//
//  Created by Masud Shuvo on 11/11/18.
//  Copyright © 2018 Masud Shuvo. All rights reserved.
//

import Foundation

class Utility {
    static func store(recipes: [Recipe]) {
        let userDefaults = UserDefaults.standard
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: recipes)
        userDefaults.set(encodedData, forKey: "recipes")
        userDefaults.synchronize()
    }
    
    static func retrive() -> [Recipe] {
        guard let decoded = UserDefaults.standard.data(forKey: "recipes") else {
            return []
        }
        return NSKeyedUnarchiver.unarchiveObject(with: decoded) as! [Recipe]
    }
}
