//
//  RecipeViewModel.swift
//  Recipes
//
//  Created by Masud Shuvo on 11/11/18.
//  Copyright © 2018 Masud Shuvo. All rights reserved.
//

import UIKit

protocol RecipeViewModelDelegate: class {
    func displayRecipe(_ viewModel: RecipeViewModel, urlRequest: URLRequest)
}

class RecipeViewModel: NSObject {
    var recipe: Recipe!
    weak var delegate: RecipeViewModelDelegate?
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    func displayRecipe() {
        let url = URL (string: self.recipe.href)
        let requestURL = URLRequest(url: url!)
        self.delegate?.displayRecipe(self, urlRequest: requestURL)
    }
    
    func addToFavorite() {
        var recipes = Utility.retrive()
        recipes.append(recipe)
        Utility.store(recipes: recipes)
    }
    
    func removeFromFavorite() {
        var recipes = Utility.retrive()
        for (index, storedRecipe) in recipes.enumerated() {
            if storedRecipe.isEqual(recipe) == true {
                recipes.remove(at: index)
            }
        }
        Utility.store(recipes: recipes)
    }
    
    func isFavorite() -> Bool {
        let recipes = Utility.retrive()
        for storedRecipe in recipes {
            if storedRecipe.isEqual(recipe) == true {
                return true
            }
        }
        return false
    }
}
