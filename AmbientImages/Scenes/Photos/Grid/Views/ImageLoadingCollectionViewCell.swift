//
//  ImageLoadingCollectionViewCell.swift
//  AmbientImages
//
//  Created by Christian Cieza on 21/09/21.
//

import UIKit

class ImageLoadingCollectionViewCell: UICollectionViewCell {

    private let loadingIndicator = configure(UIActivityIndicatorView(style: .medium)) {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let errorImageView = configure(UIImageView()) {
        $0.image = UIImage(systemName: "arrow.clockwise")
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("ImageLoadingCollectionViewCell init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        addSubview(errorImageView)
        NSLayoutConstraint.activate([
            errorImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            errorImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/4),
            errorImageView.heightAnchor.constraint(equalTo: errorImageView.widthAnchor, multiplier: 1)
        ])
    }

    func setup(with state: State) {
        switch state {
        case .failed: stopLoading()
        default: startLoading()
        }
    }

    private func startLoading() {
        loadingIndicator.startAnimating()
        errorImageView.isHidden = true
    }

    private func stopLoading() {
        loadingIndicator.stopAnimating()
        errorImageView.isHidden = false
    }

}
