//
//  TestDataLoader.swift
//  RecipesTests
//
//  Created by Masud Shuvo on 11/11/18.
//  Copyright © 2018 Masud Shuvo. All rights reserved.
//

import Foundation

class TestDataLoader {
    static func data(fileName: String, type:String?) -> Data {
        let bundle = Bundle(for: TestDataLoader.self)
        guard let url = bundle.url(forResource: fileName, withExtension: type),
            let data = try? Data(contentsOf: url) else {
                fatalError("Could not load the file")
        }
        return data
    }
}
