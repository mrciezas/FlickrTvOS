//
//  ImageCollectionViewCell.swift
//  AmbientImages
//
//  Created by Christian Cieza on 20/09/21.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    private let imageView: UIImageView = configure(UIImageView()) {
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .systemGray
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let contentStackView: UIStackView = configure(UIStackView()) {
        $0.axis = .vertical
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let titleLabel: UILabel = configure(UILabel()) {
        $0.textColor = .white
        $0.font = .preferredFont(forTextStyle: .subheadline)
    }

    private let descriptionLabel: UILabel = configure(UILabel()) {
        $0.textColor = .white
        $0.font = .preferredFont(forTextStyle: .subheadline)
    }

    private var contentGradientLayer: CAGradientLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("ImageCollectionViewCell init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        self.imageView.image = nil
        self.imageView.cancelImageLoad()
    }

    override func draw(_ rect: CGRect) {
        guard contentGradientLayer == nil else { return }
        let height = rect.height / 3
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: rect.size.height - height, width: rect.size.width, height: height)
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        layer.insertSublayer(gradientLayer, below: contentStackView.layer)
        contentGradientLayer = gradientLayer
    }

    private func setupView() {
        clipsToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2
        addSubview(imageView)
        addSubview(contentStackView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
        imageView.pinToSuperView()
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            contentStackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 16)
        ])
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        coordinator.addCoordinatedAnimations { [weak self] in
            self?.updateFocus()
        }
    }

    private func updateFocus() {
        self.layer.borderWidth = isFocused ? 8 : 2
        self.transform = isFocused ? CGAffineTransform(scaleX: 1.01, y: 1.01) : .identity
    }

    func setup(with model: ImageCellModel) {
        self.titleLabel.text = model.title
        self.descriptionLabel.text = model.subtitle
        self.imageView.loadImage(at: model.thumbnailURL)
    }

}

protocol ImageCellModel {

    var title: String { get }
    var subtitle: String { get }
    var thumbnailURL: URL { get }

}
