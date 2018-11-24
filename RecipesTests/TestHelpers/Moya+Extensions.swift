//
//  Moya+Extensions.swift
//  RecipesTests
//
//  Created by Masud Shuvo on 11/11/18.
//  Copyright © 2018 Masud Shuvo. All rights reserved.
//

import Foundation
import Moya

extension MoyaProvider {
    convenience init(sampleResponseClosure: @escaping @autoclosure () -> EndpointSampleResponse, stubBehavior: StubBehavior = .immediate) {
        let endpointMapping: EndpointClosure = { target in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            return Endpoint(
                url: defaultEndpoint.url,
                sampleResponseClosure: sampleResponseClosure,
                method: defaultEndpoint.method,
                task: defaultEndpoint.task,
                httpHeaderFields: defaultEndpoint.httpHeaderFields)
        }
        self.init(endpointClosure: endpointMapping, stubClosure: {_ in
            stubBehavior})
    }
}
