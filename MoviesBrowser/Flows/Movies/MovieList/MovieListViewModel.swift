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
    let loadMoreSubject = PublishSubject<Void>()
    let searchQuerySubject = PublishSubject<String>()

    // out
    var title: Observable<String> { .just("Now playing") }
    var dataSource: Observable<[AnimatableSectionModel<String, MovieCellViewModel>]> {
        Observable.combineLatest(dataLoader.movies.distinctUntilChanged(),
                                 favoritesRepository.favorites.distinctUntilChanged())
            .map { models, favorites in
                models.map { MovieCellViewModel(model: $0,
                                                isFavorite: favorites.contains($0.identifier)) }
            }
            .map { [.init(model: "section", items: $0)] }
    }

    private let favoritesRepository: FavoritesRepositoryProtocol
    private let dataLoader = MovieListDataLoader()

    private let disposeBag = DisposeBag()

    init(favoritesRepository: FavoritesRepositoryProtocol) {
        self.favoritesRepository = favoritesRepository
        setupBinding()
    }

    private func setupBinding() {
        loadMoreSubject
            .map { .loadMore }
            .bind(to: dataLoader.loadSubject)
            .disposed(by: disposeBag)
        reloadSubject
            .map { .loadFirstPage }
            .bind(to: dataLoader.loadSubject)
            .disposed(by: disposeBag)
        searchQuerySubject.bind(to: dataLoader.searchQuerySubject).disposed(by: disposeBag)
    }
}
