//  
//  MovieCell.swift
//  MoviesBrowser
//
//  Created by Paweł Zgoda-Ferchmin on 19/06/2023.
//

import UIKit
import RxSwift

class MovieCell: UITableViewCell, LoadableCell {

    // MARK: - IBOutlets
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var releaseDateLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var favoriteView: UIImageView!
    @IBOutlet private var coverImageView: UIImageView! {
        didSet {
            setupShadow()
        }
    }

    private var disposeBag = DisposeBag()

    func setup(viewModel: MovieCellViewModel) {
        viewModel.title.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.releaseDate.bind(to: releaseDateLabel.rx.text).disposed(by: disposeBag)
        viewModel.description.bind(to: descriptionLabel.rx.text).disposed(by: disposeBag)
        viewModel.isFavorite.map { !$0 }.bind(to: favoriteView.rx.isHidden).disposed(by: disposeBag)
        viewModel.posterUrl
            .compactMap { $0 }
            .flatMapLatest { MBImageResolver(url: $0).asObservable() }
            .bind(to: coverImageView.rx.image)
            .disposed(by: disposeBag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        coverImageView.image = UIImage(systemName: "photo.artframe")
    }

    private func setupShadow() {
        coverImageView.backgroundColor = .white
        coverImageView.layer.shadowColor = UIColor.black.cgColor
        coverImageView.layer.shadowOpacity = 0.5
        coverImageView.layer.shadowOffset = .zero
        coverImageView.layer.shadowRadius = 5
    }
}
