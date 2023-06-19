//  
//  MovieDetailsViewController.swift
//  MoviesBrowser
//
//  Created by Paweł Zgoda-Ferchmin on 19/06/2023.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    @IBOutlet private var coverImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var metadataLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var genresStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func configure(model: MBMovie) {
        titleLabel.text = model.title
        metadataLabel.text = [model.releaseDate, model.duration ?? "-"].joined(separator: " - ")
        descriptionLabel.text = model.description

        MBImageResolver(url: model.posterUrl).getImage { [weak self] image in
            self?.coverImageView.image = image
        }
    }
}
