//
//  MovieListDataLoader.swift
//  MoviesBrowser
//
//  Created by Paweł Zgoda-Ferchmin on 20/06/2023.
//

import Foundation
import RxSwift

enum DataLoaderEvent {
    case loadFirstPage
    case loadMore
}

class MovieListDataLoader {
    let loadSubject = PublishSubject<DataLoaderEvent>()
    let searchQuerySubject = PublishSubject<String>()

    var movies: Observable<[MBMovie]> {
        moviesSubject.asObservable().distinctUntilChanged()
    }

    private let pageSubject = BehaviorSubject<Int>(value: 0)
    private let moviesSubject = BehaviorSubject<[MBMovie]>(value: [])
    private let resultsSubject = BehaviorSubject<[MBMovie]>(value: [])
    private let paginationEnded = BehaviorSubject<Bool>(value: false)

    private let disposeBag = DisposeBag()

    public init() {
        setupPaginationBinding()
        setupRequestBinding()
    }

    private func setupPaginationBinding() {
        let resetState = Observable.combineLatest(loadSubject.filter { $0 == .loadFirstPage },
                                                  searchQuerySubject.distinctUntilChanged())
            .observe(on: MainScheduler.asyncInstance)
            .share()
        resetState.map { _ in 0 }.bind(to: pageSubject).disposed(by: disposeBag)
        resetState.map { _ in [] }.bind(to: resultsSubject).disposed(by: disposeBag)
        resetState.map { _ in .loadMore }.bind(to: loadSubject).disposed(by: disposeBag)
        resetState.map { _ in false }.bind(to: paginationEnded).disposed(by: disposeBag)
    }

    private func setupRequestBinding() {
        let loadMore = loadSubject.asObservable()
            .filter { $0 == .loadMore }
            .observe(on: MainScheduler.asyncInstance)
            .withLatestFrom(paginationEnded)
            .filter { $0 == false }
            .map { _ in }
            .share()

        loadMore.withLatestFrom(pageSubject.asObservable())
            .map { $0 + 1 }
            .bind(to: pageSubject)
            .disposed(by: disposeBag)

        let request = loadMore
            .withLatestFrom(searchQuerySubject)
            .filter { $0.isEmpty }
            .withLatestFrom(pageSubject.asObservable())
            .map { page -> NowPlayingQuery in
                NowPlayingQuery(page: page)
            }
            .flatMapLatest { MBRequest(query: $0).asObservable() }
            .share(replay: 1, scope: .forever)

        let searchRequest = loadMore
            .withLatestFrom(searchQuerySubject)
            .filter { !$0.isEmpty }
            .withLatestFrom(pageSubject.asObservable()) { ($0, $1) }
            .map { query, page -> SearchMoviesQuery in
                SearchMoviesQuery(query: query, page: page)
            }
            .flatMapLatest { MBRequest(query: $0).asObservable() }
            .share(replay: 1, scope: .forever)

        let results = Observable.merge(request, searchRequest).map { $0.value?.movies ?? [] }

        results
            .map { $0.isEmpty }
            .bind(to: paginationEnded)
            .disposed(by: disposeBag)

        let success = results
            .withLatestFrom(resultsSubject.asObservable()) { $1 + $0 }
            .share()

        success.bind(to: moviesSubject, resultsSubject).disposed(by: disposeBag)
    }
}
