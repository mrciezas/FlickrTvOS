//
//  PhotoDetailViewController.swift
//  AmbientImages
//
//  Created by Christian Cieza on 22/09/21.
//

import UIKit
import Combine

class PhotoDetailViewController: UIViewController {

    var viewModel: PhotoDetailViewModel!
    private var cancellables: [AnyCancellable] = []

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var loadingView: LoadingStateView!
    private var aspectRatioConstraint: NSLayoutConstraint?
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        [loadingView]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
    }

    private func setupView() {
        // Gestures
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft(_:)))
        leftSwipeGesture.direction = .left
        view.addGestureRecognizer(leftSwipeGesture)
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft(_:)))
        rightSwipeGesture.direction = .right
        view.addGestureRecognizer(rightSwipeGesture)
        // LoadingView
        loadingView.addTargetForRetryButton(target: self, action: #selector(didTapRetryButton))
    }

    private func setupBindings() {
        viewModel.$state
            .sink { [weak self] state in
                self?.handleState(state)
        }.store(in: &cancellables)
        viewModel.$currentImageInfo
            .compactMap { $0 }
            .sink { [weak self] info in
                self?.reloadImageView(with: info)
            }.store(in: &cancellables)
    }

    private func handleState(_ state: State) {
        switch state {
        case .start:
            viewModel.loadData()
        case .loading:
            updateToLoadingState()
        case .loaded:
            loadingView.stopLoading()
        case .failed(let error):
            loadingView.update(with: error)
        }
    }

    private func updateToLoadingState() {
        loadingView.startLoading()
        imageView.image = nil
    }

    private func reloadImageView(with info: (image: UIImage, aspectRatio: Double)) {
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.image = info.image
    }

    // MARK: - Actions

    @objc private func didTapRetryButton() {
        viewModel.reloadImage()
    }

    // MARK: - Gestures

    @objc private func didSwipeLeft(_ recognizer: UISwipeGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            guard let direction = PhotoDetailViewModel.Direction(recognizer.direction) else { return }
            viewModel.changePhoto(on: direction)
        default: break
        }
    }

}
