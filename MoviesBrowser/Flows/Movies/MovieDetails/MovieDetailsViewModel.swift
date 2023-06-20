//
//  MovieDetailsViewModel.swift
//  MoviesBrowser
//
//  Created by Paweł Zgoda-Ferchmin on 20/06/2023.
//

import Foundation
import RxSwift

struct MovieDetailsViewModel {

    // out
    var movieTitle: Observable<String?> { model.map { $0.title } }
    var releaseDate: Observable<String> { model.map { $0.releaseDate ?? "" }.map { "Release: \($0)" } }
    var description: Observable<String?> { model.map { $0.description } }
    var posterUrl: Observable<URL?> { model.map { $0.posterUrl } }
    var rating: Observable<String> {
        model.map {
            guard let rating = $0.rating else { return "" }
            return "\(rating) / 10"
        }
    }
    var identifier: Observable<Int> { model.map { $0.identifier } }
    var isFavorite: Observable<Bool> {
        favoritesRepository.favorites
            .withLatestFrom(identifier) { ($0, $1) }
            .map { $0.contains($1) }
    }

    // in
    let setFavoriteSubject = PublishSubject<Bool>()

    private let favoritesRepository: FavoritesRepositoryProtocol
    private let model: Observable<MBMovie>
    private let disposeBag = DisposeBag()

    init(model: MBMovie, favoritesRepository: FavoritesRepositoryProtocol) {
        self.model = .just(model)
        self.favoritesRepository = favoritesRepository

        setupBinding()
    }

    private func setupBinding() {
        setFavoriteSubject
            .withLatestFrom(identifier) { ($0, $1) }
            .subscribe(onNext: { [favoritesRepository] favorite, identifier in
                if favorite {
                    favoritesRepository.addFavoriteSubject.onNext(identifier)
                } else {
                    favoritesRepository.removeFavoriteSubject.onNext(identifier)
                }
            })
            .disposed(by: disposeBag)
    }
}
