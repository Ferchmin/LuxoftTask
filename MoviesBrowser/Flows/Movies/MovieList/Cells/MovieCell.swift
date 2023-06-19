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
    @IBOutlet private var coverImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var releaseDateLabel: UILabel!
    @IBOutlet private var durationLabel: UILabel!

    private var disposeBag = DisposeBag()

    func setup(viewModel: MovieCellViewModel) {
        viewModel.title.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        viewModel.releaseDate.bind(to: releaseDateLabel.rx.text).disposed(by: disposeBag)
        viewModel.duration.bind(to: durationLabel.rx.text).disposed(by: disposeBag)
        viewModel.posterUrl
            .flatMapLatest { MBImageResolver(url: $0).asObservable() }
            .bind(to: coverImageView.rx.image)
            .disposed(by: disposeBag)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        coverImageView.image = nil
    }
}
