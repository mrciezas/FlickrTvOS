//
//  PhotosSearchContainerViewController.swift
//  AmbientImages
//
//  Created by Christian Cieza on 24/09/21.
//

import UIKit

class PhotosSearchContainerViewController: UIViewController {

    private var searchController: UISearchController = {
        let searchResultsController: SearchViewController = .instantiate()
        let searchController = UISearchController(searchResultsController: searchResultsController)
        searchController.searchResultsUpdater = searchResultsController
        searchController.searchControllerObservedScrollView = searchResultsController.photosCollectionView
        return searchController
    }()

    private lazy var searchContainer: UISearchContainerViewController = {
        let searchContainer = UISearchContainerViewController(searchController: searchController)
        return searchContainer
    }()

    private var searchResultViewController: SearchViewController? {
        searchController.searchResultsUpdater as? SearchViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addViewController(searchContainer)
    }

    private func addViewController(_ viewController: UIViewController) {
        addChild(viewController)
        viewController.didMove(toParent: self)
        view.addSubview(viewController.view)
        viewController.view.pinToSuperView()
        view.layoutIfNeeded()
    }

}
