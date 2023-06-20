//
//  MBMovieResponse.swift
//  MoviesBrowser
//
//  Created by Paweł Zgoda-Ferchmin on 20/06/2023.
//

import Foundation

struct MBMoviesResponse: Codable, Equatable {
    let movies: [MBMovie]

    private enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

struct NowPlayingQuery: MBQuery {
    typealias ResultType = MBMoviesResponse

    var url: URL { Config.baseUrl.appendingPathComponent("/movie/now_playing") }
    var method: HttpMethod { .get }
    var parameters: [String: Any] { ["page": page] }

    private let page: Int

    init(page: Int) {
        self.page = page
    }
}

struct SearchMoviesQuery: MBQuery {
    typealias ResultType = MBMoviesResponse

    var url: URL { Config.baseUrl.appendingPathComponent("/search/movie") }
    var method: HttpMethod { .get }
    var parameters: [String: Any] {
         ["page": page,
          "query": query]
    }

    private let query: String
    private let page: Int

    init(query: String, page: Int) {
        self.query = query
        self.page = page
    }
}
