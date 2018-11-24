//
//  RecipeList.swift
//  Recipes
//
//  Created by Masud Shuvo on 11/10/18.
//  Copyright © 2018 Masud Shuvo. All rights reserved.
//

import UIKit

struct RecipeList: Decodable {
    let results: [Recipe]
    
    init(results: [Recipe]) {
        self.results = results
    }
}

class Recipe: NSObject, Decodable, NSCoding {
    let title: String
    let href: String
    let ingredients: String
    let thumbnail: String
    
    init(title: String, href: String, ingredients: String, thumbnail: String) {
        self.title = title
        self.href = href
        self.ingredients = ingredients
        self.thumbnail = thumbnail
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: "title")
        aCoder.encode(href, forKey: "href")
        aCoder.encode(ingredients, forKey: "ingredients")
        aCoder.encode(thumbnail, forKey: "thumbnail")
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let title = aDecoder.decodeObject(forKey: "title") as! String
        let href = aDecoder.decodeObject(forKey: "href") as! String
        let ingredients = aDecoder.decodeObject(forKey: "ingredients") as! String
        let thumbnail = aDecoder.decodeObject(forKey: "thumbnail") as! String
        self.init(title: title, href: href, ingredients: ingredients, thumbnail: thumbnail)
    }
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? Recipe {
            return self.title == object.title &&
                self.href == object.href &&
                self.ingredients == object.ingredients &&
                self.thumbnail == object.thumbnail
        } else {
            return false
        }
    }
}


