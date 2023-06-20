//
//  MBMovie.swift
//  MoviesBrowser
//
//  Created by Paweł Zgoda-Ferchmin on 19/06/2023.
//

import Foundation

struct MBMoviesResponse: Codable, Equatable {
    let movies: [MBMovie]

    private enum CodingKeys: String, CodingKey {
        case movies = "results"
    }
}

struct MBMovie: Codable, Equatable {
    let identifier: Int
    let title: String?
    let releaseDate: String?
    let rating: Float?
    let description: String?

    private let posterPath: String?

    var posterUrl: URL? {
        guard let posterPath = posterPath else { return nil }
        return Config.imageUrl.appendingPathComponent(posterPath)
    }

    private enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case title = "title"
        case releaseDate = "release_date"
        case rating = "vote_average"
        case posterPath = "poster_path"
        case description = "overview"
    }
}

struct NowPlayingQuery: MBQuery {
    typealias ResultType = MBMoviesResponse

    var url: URL { Config.baseUrl.appendingPathComponent("/movie/now_playing") }
    var method: HttpMethod { .get }
    var parameters: [String : Any] {
         ["page": page]
    }

    private let page: Int

    init(page: Int) {
        self.page = page
    }
}

struct SearchMoviesQuery: MBQuery {
    typealias ResultType = MBMoviesResponse

    var url: URL { Config.baseUrl.appendingPathComponent("/search/movie") }
    var method: HttpMethod { .get }
    var parameters: [String : Any] {
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
