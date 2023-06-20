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
    let title: String
    let releaseDate: String
    let rating: Float
    let description: String

    private let posterPath: String

    var posterUrl: URL {
        Config.imageUrl.appendingPathComponent(posterPath)
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
        ["language": "en-US",
         "page": "undefined",
         "api_key": "581158870b0759a89b6770163d7ac138"]
    }
}
