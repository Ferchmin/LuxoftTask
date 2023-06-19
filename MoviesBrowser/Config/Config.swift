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
    static let apiAccessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI1ODExNTg4NzBiMDc1OWE4OWI2NzcwMTYzZDdhYzEzOCIsInN1YiI6IjY0OTA2MmQxYzJmZjNkMDEzOWFmNjQwMCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.CngoNwu6JRnW5N9L4i7wGaApKlgabJW7s_SmixP_rBc"

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
