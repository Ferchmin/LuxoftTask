//
//  MBMovie.swift
//  MoviesBrowser
//
//  Created by Paweł Zgoda-Ferchmin on 19/06/2023.
//

import Foundation

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
