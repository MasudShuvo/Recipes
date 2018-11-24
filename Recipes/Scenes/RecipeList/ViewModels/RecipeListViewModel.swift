//
//  RecipeListViewModel.swift
//  Recipes
//
//  Created by Masud Shuvo on 11/10/18.
//  Copyright © 2018 Masud Shuvo. All rights reserved.
//

import UIKit

protocol RecipeListViewModelDelegate: class {
    func updateRecipeList(_ viewModel: RecipeListViewModel)
}

class RecipeListViewModel: NSObject {
    weak var delegate: RecipeListViewModelDelegate?
    let recipeService: RecipeListService
    var recipes: [Recipe]
    var searchText: String = ""
    var pageNumber = 1
    
    init(recipeService: RecipeListService) {
        self.recipeService = recipeService
        self.recipes = []
    }
    
    func updateRecipeList(searchString: String) {
        searchText = searchString
        pageNumber = 1
        recipes.removeAll()
        self.delegate?.updateRecipeList(self)
        fetchRecipes()
    }
    
    func fetchRecipes() {
        self.recipeService.fetchRecipes(searchString: searchText, pageNumber: pageNumber)
            .startWithResult { (result) in
                switch result {
                case let .success(recipes):
                    self.recipes.append(contentsOf: recipes)
                    DispatchQueue.main.async {
                        if recipes.count > 0 {
                            self.pageNumber += 1
                            self.delegate?.updateRecipeList(self)
                        }
                    }
                    break
                case .failure(_):
                    break
                }
        }
    }
}
