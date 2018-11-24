//
//  FavoriteListViewModelSpec.swift
//  RecipesTests
//
//  Created by Masud Shuvo on 11/11/18.
//  Copyright © 2018 Masud Shuvo. All rights reserved.
//

import Quick
import Nimble
@testable import Recipes

class FavoriteListViewModelSpec: QuickSpec {
    override func spec() {
        describe("displayFavorites") {
            let sut = FavoriteListViewModel()
            let favoriteList = [
                Recipe(title: "Vegetable-Pasta Oven Omelet", href: "http://find.myrecipes.com/recipes/recipefinder.dyn?action=displayRecipe&recipe_id=520763", ingredients: "tomato, onions, red pepper, garlic, olive oil, zucchini, cream cheese, vermicelli, eggs, parmesan cheese, milk, italian seasoning, salt, black pepper", thumbnail: "http://img.recipepuppy.com/560556.jpg"),
                Recipe(title: "Roasted Pepper and Bacon Omelet", href: "http://www.bigoven.com/43919-Roasted-Pepper-and-Bacon-Omelet-recipe.html", ingredients: "eggs, salt, black pepper, butter, black pepper, bacon, onions, garlic, roasted red peppers, oregano, black pepper", thumbnail: ""),
                Recipe(title: "Broccoli and Cheese Omelet", href: "http://www.bigoven.com/45151-Broccoli-and-Cheese-Omelet-recipe.html", ingredients: "onions, garlic, chicken broth, cottage cheese, oregano, black pepper, egg substitute, bread, mozzarella cheese, butter", thumbnail: "")
            ]
            Utility.store(recipes: favoriteList)
            sut.displayFavorites()
            it("should able to fetch all the favorite recipes") {
                expect(sut.favorites.count).to(equal(favoriteList.count))
                for (index, recipe) in sut.favorites.enumerated() {
                    expect(recipe.isEqual(favoriteList[index])) == true
                }
            }
        }
    }
}
