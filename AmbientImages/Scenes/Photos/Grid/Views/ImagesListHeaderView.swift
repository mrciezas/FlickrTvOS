//
//  ImagesListHeaderView.swift
//  AmbientImages
//
//  Created by Christian Cieza on 21/09/21.
//

import UIKit

class ImageListHeaderView: UICollectionReusableView {

    private let titleLabel = configure(UILabel()) {
        $0.textColor = .white
        $0.font = .preferredFont(forTextStyle: .headline)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("ImageListHeaderView  init(coder:) has not been implemented")
    }

    private func setupView() {
        addSubview(titleLabel)
        titleLabel.pinToSuperView(NSDirectionalEdgeInsets(sameValue: Spacing.medium))
    }

    func setup(_ title: String) {
        titleLabel.text = title
    }

}
