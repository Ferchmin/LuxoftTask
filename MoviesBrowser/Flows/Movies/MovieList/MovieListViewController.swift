//  
//  MovieListViewController.swift
//  MoviesBrowser
//
//  Created by Paweł Zgoda-Ferchmin on 19/06/2023.
//

import UIKit
import RxSwift
import RxDataSources

enum MovieList: Storyboard {
    typealias InitialControllerType = MovieListViewController
}

class MovieListViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet private var searchBar: UISearchBar!
    @IBOutlet private var tableView: UITableView! {
        didSet {
            tableView.register(UINib(nibName: MovieCell.cellIdentifier, bundle: nil),
                               forCellReuseIdentifier: MovieCell.cellIdentifier)
        }
    }

    var onShowMovieDetails: ((MBMovie) -> Void)?
    var viewModel: MovieListViewModel?

    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let viewModel = viewModel else { return }
        setup(with: viewModel)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel?.reloadSubject.onNext(())
    }

    private typealias DataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, MovieCellViewModel>>

    private func setup(with viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        // initialize new disposeBag to dispose previous bindings
        self.disposeBag = DisposeBag()

        viewModel.title.bind(to: rx.title).disposed(by: disposeBag)

        let dataSource = DataSource(configureCell: { _, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.cellIdentifier, for: indexPath)
            (cell as? MovieCell)?.setup(viewModel: item)
            return cell
        })

        viewModel.dataSource.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)

        tableView.rx.modelSelected(MovieCellViewModel.self)
            .flatMapLatest { $0.model }
            .subscribe(onNext: { [weak self] in self?.onShowMovieDetails?($0) })
            .disposed(by: disposeBag)

        tableView.rx.scrolledToBottom
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.instance)
            .bind(to: viewModel.loadMoreSubject)
            .disposed(by: disposeBag)

        searchBar.rx.text
            .map { $0 ?? "" }
            .distinctUntilChanged()
            .debounce(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .bind(to: viewModel.searchQuerySubject)
            .disposed(by: disposeBag)
    }
}

private extension Reactive where Base: UIScrollView {
    var scrolledToBottom: Observable<Void> {
        base.rx.contentOffset
            .distinctUntilChanged()
            .map { [unowned base] offset -> Bool in
                guard offset.y > 0 else { return false }
                let contentSizeHeight = base.contentSize.height
                let viewHeight = base.frame.height
                return offset.y >= contentSizeHeight - viewHeight
            }
            .distinctUntilChanged()
            .filter { $0 }
            .map { _ in }
    }
}
