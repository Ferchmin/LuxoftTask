//
//  MBQuery.swift
//  MoviesBrowser
//
//  Created by Paweł Zgoda-Ferchmin on 19/06/2023.
//

import Foundation

protocol MBQuery {
    associatedtype ResultType: Decodable

    var url: URL { get }
    var parameters: [String: Any] { get }
    var method: HttpMethod { get }
}

extension MBQuery {
    var parameters: [String: Any] { [:] }
    // default parameters can be overriden by custom query parameters
    var allParameters: [String: Any] { defaultParameters.merging(parameters) { $1 } }

    var defaultParameters: [String: Any] {
            ["language": "en-US",
             "api_key": Config.apiKey]
    }
}

enum HttpMethod: String {
    case get
    case post
    case patch
    case put
    case delete
}
