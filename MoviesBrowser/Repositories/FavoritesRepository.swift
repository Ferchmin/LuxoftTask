//
//  FavoritesRepository.swift
//  MoviesBrowser
//
//  Created by Paweł Zgoda-Ferchmin on 20/06/2023.
//

import Foundation
import RxSwift

private let favoritesKey = "kFavorites"

protocol FavoritesRepositoryProtocol {
    var favorites: Observable<Set<Int>> { get }
    var addFavoriteSubject: PublishSubject<Int> { get }
    var removeFavoriteSubject: PublishSubject<Int> { get }
}

class FavoritesRepository: FavoritesRepositoryProtocol {
    var favorites: Observable<Set<Int>> {
        UserDefaults.standard.rx.observe([Int].self, favoritesKey)
            .map { $0 ?? [] }
            .map { Set($0) }
    }

    let addFavoriteSubject = PublishSubject<Int>()
    let removeFavoriteSubject = PublishSubject<Int>()

    private let disposeBag = DisposeBag()

    init() {
        setupBinding()
    }

    private func setupBinding() {
        addFavoriteSubject
            .withLatestFrom(favorites) { ($0, $1) }
            .map { newIdentifier, favorites -> Set<Int> in
                var newFavorites = favorites
                newFavorites.insert(newIdentifier)
                return newFavorites
            }
            .subscribe(onNext: { [weak self] favorites in self?.setFavorites(to: favorites) })
            .disposed(by: disposeBag)

        removeFavoriteSubject
            .withLatestFrom(favorites) { ($0, $1) }
            .map { identifier, favorites -> Set<Int> in
                var newFavorites = favorites
                newFavorites.remove(identifier)
                return newFavorites
            }
            .subscribe(onNext: { [weak self] favorites in self?.setFavorites(to: favorites) })
            .disposed(by: disposeBag)
    }

    private func setFavorites(to favorites: Set<Int>) {
        UserDefaults.standard.set(Array(favorites), forKey: favoritesKey)
    }
}
