//
//  RecipeListServiceSpec.swift
//  Recipes
//
//  Created by Masud Shuvo on 11/10/18.
//  Copyright © 2018 Masud Shuvo. All rights reserved.
//

import Quick
import Nimble
import Moya

@testable import Recipes

class RecipeListServiceSpec: QuickSpec {
    override func spec() {
        describe("fetchRecipes(searchString:, pageNumber:)") {
            context("Successful response") {
                let successfulResponseJson = "recipe_valid_response"

                let expected = [
                    Recipe(title: "Vegetable-Pasta Oven Omelet", href: "http://find.myrecipes.com/recipes/recipefinder.dyn?action=displayRecipe&recipe_id=520763", ingredients: "tomato, onions, red pepper, garlic, olive oil, zucchini, cream cheese, vermicelli, eggs, parmesan cheese, milk, italian seasoning, salt, black pepper", thumbnail: "http://img.recipepuppy.com/560556.jpg"),
                    Recipe(title: "Roasted Pepper and Bacon Omelet", href: "http://www.bigoven.com/43919-Roasted-Pepper-and-Bacon-Omelet-recipe.html", ingredients: "eggs, salt, black pepper, butter, black pepper, bacon, onions, garlic, roasted red peppers, oregano, black pepper", thumbnail: ""),
                    Recipe(title: "Broccoli and Cheese Omelet", href: "http://www.bigoven.com/45151-Broccoli-and-Cheese-Omelet-recipe.html", ingredients: "onions, garlic, chicken broth, cottage cheese, oregano, black pepper, egg substitute, bread, mozzarella cheese, butter", thumbnail: "")
                ]
                itBehavesLike("fetch recipe list") { ["fileName": successfulResponseJson, "expected": expected] }
            }

            context("empty response") {
                let emptyResponseJson = "recipe_empty_response"
                itBehavesLike("fetch empty room list") { ["fileName": emptyResponseJson] }
            }

            context("error response") {
                let provider = MoyaProvider<RecipeListServiceTarget>(sampleResponseClosure: .networkResponse(400, Data()))
                let service = RecipeListService(provider: provider)

                it("should return error") {
                    guard let result = service.fetchRecipes(searchString: "", pageNumber: 1).single()
                        else {
                            fail("could not find recipe")
                            return
                    }
                    expect({
                        switch result {
                        case .success:
                            return .failed(reason: "should fail")
                        case .failure:
                            return .succeeded
                        }
                    }).to(succeed())
                }
            }
        }
    }
}

private class RoomServiceSharedExamplesConfiguration: QuickConfiguration {
    override static func configure(_ configuration: Configuration) {
        sharedExamples("fetch recipe list") { (context: SharedExampleContext) in
            let context = context()
            let fileName = context["fileName"] as! String
            let data = TestDataLoader.data(fileName: fileName, type: "json")
            let provider = MoyaProvider<RecipeListServiceTarget>(sampleResponseClosure: .networkResponse(200, data))
            let service = RecipeListService(provider: provider)

            let expected = context["expected"] as! [Recipe]

            it("should return available recipe") {
                    guard let result = service.fetchRecipes(searchString: "", pageNumber: 1).single()
                    else {
                        fail("could not find recipe")
                        return
                }
                expect({
                    switch result {
                    case .success(let recipes) where recipes == expected:
                        return .succeeded
                    default:
                        return .failed(reason: "should same as expected")
                    }
                }).to(succeed())
            }
        }
        sharedExamples("fetch empty room list") { (context: SharedExampleContext) in
            let context = context()
            let fileName = context["fileName"] as! String
            let data = TestDataLoader.data(fileName: fileName, type: "json")
            let provider = MoyaProvider<RecipeListServiceTarget>(sampleResponseClosure: .networkResponse(200, data))
            let service = RecipeListService(provider: provider)

            it("should return empty recipe list") {
                guard let result = service.fetchRecipes(searchString: "", pageNumber: 1).single()
                    else {
                        fail("could not find recipe")
                        return
                }
                expect({
                    switch result {
                    case .success(let recipes) where recipes.count == 0:
                        return .succeeded
                    default:
                        return .failed(reason: "should same as expected")
                    }
                }).to(succeed())
            }
        }
    }
}
