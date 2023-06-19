//
//  MovieCellViewModel.swift
//  MoviesBrowser
//
//  Created by Paweł Zgoda-Ferchmin on 19/06/2023.
//

import Foundation
import RxSwift
import RxDataSources

struct MovieCellViewModel: IdentifiableType {

    // out
    var title: Observable<String> { model.map { $0.title } }
    var releaseDate: Observable<String> { model.map { $0.releaseDate } }
    var duration: Observable<String?> { model.map { $0.duration } }
    var posterUrl: Observable<URL> { model.map { $0.posterUrl } }

    var identity: String

    private let model: Observable<MBMovie>

    init(model: MBMovie) {
        self.model = .just(model)
        self.identity = "\(model.identifier)"
    }
}

extension MovieCellViewModel: Equatable {
    static func == (lhs: MovieCellViewModel, rhs: MovieCellViewModel) -> Bool {
        lhs.identity == rhs.identity
    }
}
