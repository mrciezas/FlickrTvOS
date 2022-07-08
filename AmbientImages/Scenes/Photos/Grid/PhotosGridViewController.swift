//
//  FeedViewController.swift
//  AmbientImages
//
//  Created by Christian Cieza on 20/09/21.
//

import UIKit
import Combine

class PhotosGridViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loadingView: LoadingStateView!

    var viewModel: PhotosListViewModel!
    var cancellables: [AnyCancellable] = []

    override var preferredFocusEnvironments: [UIFocusEnvironment] { [collectionView] }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadData()
        setupBindings()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if viewModel.selectedIndexPath != nil {
            collectionView.updateFocusIfNeeded()
            collectionView.reloadData()
        }
    }

    private func setupView() {
        // LoadinView
        loadingView.addTargetForRetryButton(target: self, action: #selector(didTapRetryButton))
        // CollectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerdSupplementaryView(ImageListHeaderView.self, kind: .header)
        collectionView.registerCell(ImageCollectionViewCell.self)
        collectionView.registerCell(ImageLoadingCollectionViewCell.self)
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/3),
            heightDimension: .fractionalHeight(1)
        ))
        item.contentInsets = NSDirectionalEdgeInsets(sameValue: Spacing.medium)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1/3)
            ),
            subitem: item,
            count: 3
        )
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(100)
                ),
                elementKind: UICollectionView.SupplementaryViewKind.header.rawValue,
                alignment: .topLeading)
        ]
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout(section: section)
        collectionView.reloadData()
    }

    private func setupBindings() {
        viewModel.photosPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }.store(in: &cancellables)
        viewModel.mainStatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleState(state)
            }.store(in: &cancellables)
    }

    private func handleState(_ state: State) {
        switch state {
        case .loading:
            if viewModel.pagination == nil {
                loadingView.startLoading()
            }
        case .loaded, .start: loadingView.stopLoading()
        case .failed(let error):
            if viewModel.pagination == nil {
                loadingView.update(with: error)
            } else {
                collectionView.reloadItems(at: [IndexPath(row: viewModel.photos.count, section: 0)])
            }
        }
    }

    // MARK: - Actions

    @objc func didTapRetryButton() {
        viewModel.retryLoadPage()
    }

    // MARK: - Detail

    private func presentPhotoDetail(_ selectedIndexPath: IndexPath) {
        let viewController: PhotoDetailViewController = .instantiate()
        let viewModel = PhotoDetailViewModel(viewModel.photos, selectedIndexPath: selectedIndexPath)
        viewModel.passCurrentIndexPath
            .receive(on: DispatchQueue.main)
            .sink { indexPath in
                self.viewModel.selectedIndexPath = indexPath
        }.store(in: &cancellables)
        viewController.viewModel = viewModel

        self.present(viewController, animated: true, completion: nil)
    }

}

extension PhotosGridViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if indexPath.row < viewModel.photos.count {
            let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.setup(with: viewModel.photos[indexPath.row])
            return cell
        } else {
            let cell: ImageLoadingCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.setup(with: viewModel.mainState)
            return cell
        }
    }

    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header: ImageListHeaderView = collectionView.dequeueReusableSupplementaryView(
            ofKind: .header,
            for: indexPath
        )
        header.setup(viewModel.title)
        return header
    }

    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard indexPath.row == viewModel.photos.count,
              let loadingCell = cell as? ImageLoadingCollectionViewCell
        else { return }
        loadingCell.setup(with: viewModel.mainState)
        if !viewModel.mainState.isFailed {
            viewModel.loadNextPage()
        }
    }

    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < viewModel.photos.count {
            presentPhotoDetail(indexPath)
        } else {
            if let loadingCell = collectionView.cellForItem(at: indexPath) as? ImageLoadingCollectionViewCell {
                loadingCell.setup(with: .loading)
            }
            didTapRetryButton()
        }
    }

    func indexPathForPreferredFocusedView(in collectionView: UICollectionView) -> IndexPath? {
        return viewModel.selectedIndexPath
    }

}
