//
//  RecipeListService.swift
//  Recipes
//
//  Created by Masud Shuvo on 11/10/18.
//  Copyright © 2018 Masud Shuvo. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import Moya

class RecipeListService {
    private let provider: MoyaProvider<RecipeListServiceTarget>

    enum Error: Swift.Error {
        case moya(MoyaError)
    }

    init(provider: MoyaProvider<RecipeListServiceTarget>) {
        self.provider = provider
    }
    
    func fetchRecipes(searchString: String, pageNumber: Int) -> SignalProducer<[Recipe], Error> {
        let target = RecipeListServiceTarget(searchString: searchString, pageNumber: pageNumber)
        return provider.reactive
            .request(target)
            .filterSuccessfulStatusCodes()
            .map(RecipeList.self)
            .map { recipes in
                return recipes.results
            }
            .mapError { .moya($0) }
    }
}

struct RecipeListServiceTarget: TargetType {
    var path: String
    let searchString: String
    let pageNumber: Int
    
    init(searchString: String, pageNumber: Int) {
        self.searchString = searchString
        self.pageNumber = pageNumber
        self.path = "api"
    }
    
    var sampleData: Data {
        return Data()
    }

    var headers: [String: String]? {
        return nil
    }

    var baseURL: URL {
        return URL(string: "http://www.recipepuppy.com/")!
    }
    
    var method: Moya.Method {
        return .get
    }

    var task: Task {
        let params: [String: Any] = ["q": self.searchString,
            "p": NSNumber(integerLiteral: self.pageNumber)]
        let encoding = URLEncoding(destination: .queryString, arrayEncoding: .noBrackets)
        return .requestParameters(parameters: params, encoding: encoding)
    }
}
