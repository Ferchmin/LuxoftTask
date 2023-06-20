//
//  MovieListViewModel.swift
//  MoviesBrowser
//
//  Created by Paweł Zgoda-Ferchmin on 19/06/2023.
//

import Foundation
import RxDataSources
import RxSwift

struct MovieListViewModel {

    // in
    let reloadSubject = PublishSubject<Void>()
    let loadMoreSubject = PublishSubject<Int>()

    // out
    var title: Observable<String> { .just("Now playing") }
    var dataSource: Observable<[AnimatableSectionModel<String, MovieCellViewModel>]> {
        Observable.combineLatest(moviesSubject.distinctUntilChanged(),
                                 favoritesRepository.favorites.distinctUntilChanged())
            .map { models, favorites in
                models.map { MovieCellViewModel(model: $0,
                                                isFavorite: favorites.contains($0.identifier)) }
            }
            .map { [.init(model: "section", items: $0)] }
    }

    private let favoritesRepository: FavoritesRepositoryProtocol
    private let moviesSubject = BehaviorSubject<[MBMovie]>(value: [])
    private let disposeBag = DisposeBag()

    init(favoritesRepository: FavoritesRepositoryProtocol) {
        self.favoritesRepository = favoritesRepository
        setupBinding()
    }

    private func setupBinding() {
        let movies = reloadSubject
            .flatMapLatest { MBRequest(query: NowPlayingQuery()).asObservable() }
            .map { $0.movies }

        movies.bind(to: moviesSubject).disposed(by: disposeBag)
    }
}
