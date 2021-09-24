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

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var childContainer: UIView!

    private var cancellables: [AnyCancellable] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        addViewController(photosViewController)
        setupViewBindings()
    }

    private func addViewController(_ viewController: UIViewController) {
        addChild(viewController)
        viewController.didMove(toParent: self)
        childContainer.addSubview(viewController.view)
        viewController.view.pinToSuperView()
    }

    private func setupViewBindings() {
        textField.publisher(for: \.text)
            .sink { [weak self] (text) in
                self?.searchViewModel?.search(with: text)
            }.store(in: &cancellables)
    }

}
