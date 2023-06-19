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

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewController = MovieList.instantiate()
        let viewModel = MovieListViewModel()
        viewController.viewModel = viewModel
        navigationController.pushViewController(viewController, animated: false)
    }

    func showMovieDetails() {
        
    }
}
