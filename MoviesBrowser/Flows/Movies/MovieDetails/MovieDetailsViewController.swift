//  
//  MovieDetailsViewController.swift
//  MoviesBrowser
//
//  Created by Paweł Zgoda-Ferchmin on 19/06/2023.
//

import UIKit
import RxSwift

enum MovieDetails: Storyboard {
    typealias InitialControllerType = MovieDetailsViewController
}

class MovieDetailsViewController: UIViewController {
    @IBOutlet private var coverImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var metadataLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var genresStackView: UIStackView!
    @IBOutlet private var ratingLabel: UILabel!

    var viewModel: MovieDetailsViewModel?
    private var disposeBag = DisposeBag()

    private lazy var favoriteButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "star"),
                                     style: .plain,
                                     target: self,
                                     action: nil)
        button.tintColor = .systemYellow
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = favoriteButton

        guard let viewModel = viewModel else { return }
        setup(with: viewModel)
    }

    private func setup(with viewModel: MovieDetailsViewModel) {
        self.viewModel = viewModel
        // initialize new disposeBag to dispose previous bindings
        self.disposeBag = DisposeBag()

        viewModel.movieTitle.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.movieTitle.bind(to: rx.title).disposed(by: disposeBag)
        viewModel.description.bind(to: descriptionLabel.rx.text).disposed(by: disposeBag)
        viewModel.releaseDate.bind(to: metadataLabel.rx.text).disposed(by: disposeBag)
        viewModel.rating.bind(to: ratingLabel.rx.text).disposed(by: disposeBag)
        viewModel.posterUrl
            .flatMapLatest { MBImageResolver(url: $0).asObservable() }
            .bind(to: coverImageView.rx.image)
            .disposed(by: disposeBag)

        viewModel.isFavorite
            .map { $0 ? "star.fill" : "star" }
            .map { UIImage(systemName: $0) }
            .bind(to: favoriteButton.rx.image)
            .disposed(by: disposeBag)

        favoriteButton.rx.tap
            .withLatestFrom(viewModel.isFavorite)
            .map { !$0 }
            .bind(to: viewModel.setFavoriteSubject)
            .disposed(by: disposeBag)
    }
}
