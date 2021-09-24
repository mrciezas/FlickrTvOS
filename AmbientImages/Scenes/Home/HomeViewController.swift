//
//  HomeViewController.swift
//  AmbientImages
//
//  Created by Christian Cieza on 20/09/21.
//

import UIKit
import Combine

class HomeViewController: UIViewController {

    private var viewModel = HomeViewModel()
    var cancellables: [AnyCancellable] = []

    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var childContainer: UIView!

    private var feedViewController: PhotosGridViewController = {
        let viewController: PhotosGridViewController = .instantiate()
        viewController.viewModel = RecentPhotosViewModel()
        return viewController
    }()
    private lazy var searchViewController: SearchViewController = .instantiate()

    override var preferredFocusEnvironments: [UIFocusEnvironment] { [segmentedControl, childContainer] }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewBindigs()
        setupBindings()
    }

    // MARK: - Child ViewControllers

    private func replaceViewController(for state: HomeViewModel.State) {
        switch state {
        case .feed:
            self.removeViewController(self.searchViewController)
            self.addViewController(self.feedViewController)
        case .search:
            self.removeViewController(self.feedViewController)
            self.addViewController(self.searchViewController)
        }
    }

    private func addViewController(_ viewController: UIViewController) {
        addChild(viewController)
        viewController.didMove(toParent: self)
        childContainer.addSubview(viewController.view)
        viewController.view.pinToSuperView()
    }

    private func removeViewController(_ viewController: UIViewController) {
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }

    // MARK: - Bindings

    private func setupViewBindigs() {
        segmentedControl.publisher(for: \.selectedSegmentIndex)
            .compactMap { HomeViewModel.State(rawValue: $0) }
            .sink { [weak self] state in
                self?.viewModel.state = state
            }.store(in: &cancellables)
    }

    private func setupBindings() {
        viewModel.$state
            .removeDuplicates()
            .sink { [weak self] (state) in
                self?.replaceViewController(for: state)
        }.store(in: &cancellables)
    }

}
