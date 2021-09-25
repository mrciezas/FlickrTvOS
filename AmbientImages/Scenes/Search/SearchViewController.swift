//
//  SearchViewController.swift
//  AmbientImages
//
//  Created by Christian Cieza on 20/09/21.
//

import UIKit
import Combine

class SearchViewController: UIViewController {

    private var searchViewModel: SearchViewModel? { photosViewController.viewModel as? SearchViewModel }
    private var photosViewController: PhotosGridViewController = {
        let viewController: PhotosGridViewController = .instantiate()
        viewController.viewModel = SearchViewModel()
        return viewController
    }()

    @IBOutlet private weak var childContainer: UIView!
    var photosCollectionView: UICollectionView { photosViewController.collectionView }

    private var cancellables: [AnyCancellable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        addViewController(photosViewController)
    }

    private func addViewController(_ viewController: UIViewController) {
        addChild(viewController)
        viewController.didMove(toParent: self)
        view.addSubview(viewController.view)
        viewController.view.pinToSuperView()
    }

}

extension SearchViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text
        searchViewModel?.search(with: text)
    }

}
