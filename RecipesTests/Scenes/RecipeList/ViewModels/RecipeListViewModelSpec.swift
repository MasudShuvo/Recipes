//
//  RecipeListViewModelSpec.swift
//  RecipesTests
//
//  Created by Masud Shuvo on 11/11/18.
//  Copyright © 2018 Masud Shuvo. All rights reserved.
//

import Quick
import Nimble
import ReactiveSwift
import Result
import Moya

@testable import Recipes

class RecipeListViewModelSpec: QuickSpec {
    override func spec() {
        var sut: RecipeListViewModel!
        describe("fetchRecipes") {
            context("get successful response") {
                var expectedResult: [Recipe]!
                beforeEach {
                    let data = TestDataLoader.data(fileName: "recipe_valid_response", type: "json")
                    let provider = MoyaProvider<RecipeListServiceTarget>(sampleResponseClosure: .networkResponse(200, data))
                    let service = RecipeListService(provider: provider)
                    sut = RecipeListViewModel(recipeService: service)
                    expectedResult = (try? JSONDecoder().decode(RecipeList.self, from: data))?.results
                    sut.fetchRecipes()
                }
                describe("number of recipes") {
                    it("it should be same as expected") {
                        expect(sut.recipes.count).to(equal(expectedResult.count))
                    }
                }
            }
            context("get empty response") {
                beforeEach {
                    let data = TestDataLoader.data(fileName: "recipe_empty_response", type: "json")
                    let provider = MoyaProvider<RecipeListServiceTarget>(sampleResponseClosure: .networkResponse(200, data))
                    let service = RecipeListService(provider: provider)
                    sut = RecipeListViewModel(recipeService: service)
                    sut.fetchRecipes()
                }
                describe("number of recipes") {
                    it("it should be 0") {
                        expect(sut.recipes.count).to(equal(0))
                    }
                }
            }
            context("get error response") {
                beforeEach {
                    let provider = MoyaProvider<RecipeListServiceTarget>(sampleResponseClosure: .networkResponse(400, Data()))
                    let service = RecipeListService(provider: provider)
                    sut = RecipeListViewModel(recipeService: service)
                    sut.fetchRecipes()
                }
                describe("number of recipes") {
                    it("it should be 0") {
                        expect(sut.recipes.count).to(equal(0))
                    }
                }
            }
        }
        describe("updateRecipeList") {
            let provider = MoyaProvider<RecipeListServiceTarget>(sampleResponseClosure: .networkResponse(200, Data()))
            let service = RecipeListService(provider: provider)
            sut = RecipeListViewModel(recipeService: service)
            sut.searchText = "Old Text"
            sut.pageNumber = 100
            sut.updateRecipeList(searchString: "Omlet")
            expect(sut.searchText).to(equal("Omlet"))
            expect(sut.pageNumber).to(equal(1))
        }
    }
}
