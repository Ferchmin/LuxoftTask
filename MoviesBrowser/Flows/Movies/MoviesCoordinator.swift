//
//  MoviesCoordinator.swift
//  MoviesBrowser
//
//  Created by Paweł Zgoda-Ferchmin on 19/06/2023.
//

import Foundation
import UIKit

class MoviesCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    private let favoritesRepository: FavoritesRepositoryProtocol

    init(navigationController: UINavigationController,
         favoritesRepository: FavoritesRepositoryProtocol = FavoritesRepository()) {
        self.navigationController = navigationController
        self.favoritesRepository = favoritesRepository
    }

    func start() {
        let viewController = MovieList.instantiate()
        let viewModel = MovieListViewModel(favoritesRepository: favoritesRepository)
        viewController.viewModel = viewModel
        viewController.onShowMovieDetails = { [weak self] movie in
            self?.showMovieDetails(for: movie)
        }
        navigationController.pushViewController(viewController, animated: false)
    }

    func showMovieDetails(for movie: MBMovie) {
        let viewController = MovieDetails.instantiate()
        let viewModel = MovieDetailsViewModel(model: movie, favoritesRepository: favoritesRepository)
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: true)
    }
}
