//
//  Config.swift
//  MoviesBrowser
//
//  Created by Paweł Zgoda-Ferchmin on 19/06/2023.
//

import Foundation

struct Config {
    static let apiBaseUrl = "https://api.themoviedb.org/3"
    static let imageBaseUrl = "https://image.tmdb.org/t/p/w500"

    static let apiKey = "581158870b0759a89b6770163d7ac138"

    static var baseUrl: URL {
        guard let url = URL(string: apiBaseUrl) else {
            fatalError("Base URL invalid.")
        }
        return url
    }

    static var imageUrl: URL {
        guard let url = URL(string: imageBaseUrl) else {
            fatalError("Base URL invalid.")
        }
        return url
    }
}
