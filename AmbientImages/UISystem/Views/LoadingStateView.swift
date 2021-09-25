//
//  LoadingStateView.swift
//  AmbientImages
//
//  Created by Christian Cieza on 23/09/21.
//

import UIKit

class LoadingStateView: UIView {

    private let activityIndicator = configure(UIActivityIndicatorView()) {
        $0.style = .large
        $0.stopAnimating()
    }

    private let errorMessage = configure(UILabel()) {
        $0.font = .preferredFont(forTextStyle: .callout)
        $0.textColor = .white
        $0.numberOfLines = 0
        $0.isHidden = true
    }

    private let retryButton = configure(UIButton.init(type: .roundedRect)) {
        $0.setTitle(StaticText.retry, for: .normal)
        $0.contentHorizontalAlignment = .fill
        $0.contentVerticalAlignment = .fill
        $0.role = .primary
        $0.isHidden = true
    }

    private let contentStackView = configure(UIStackView()) {
        $0.axis = .vertical
        $0.spacing = Spacing.medium
        $0.alignment = .center
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    override var canBecomeFocused: Bool { true }
    override var preferredFocusEnvironments: [UIFocusEnvironment] { [retryButton] }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(contentStackView)
        contentStackView.pinToSuperView()
        contentStackView.addArrangedSubview(activityIndicator)
        contentStackView.addArrangedSubview(errorMessage)
        contentStackView.addArrangedSubview(retryButton)
        retryButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }

    func startLoading() {
        isHidden = false
        activityIndicator.startAnimating()
        errorMessage.isHidden = true
        retryButton.isHidden = true
    }

    func stopLoading() {
        activityIndicator.stopAnimating()
        errorMessage.isHidden = true
        retryButton.isHidden = true
        isHidden = true
    }

    func update(with error: Error) {
        isHidden = false
        activityIndicator.stopAnimating()
        errorMessage.isHidden = false
        errorMessage.text = error.localizedDescription
        retryButton.isHidden = false
        setNeedsFocusUpdate()
    }

    func addTargetForRetryButton(target: Any?, action: Selector) {
        retryButton.addTarget(target, action: action, for: .primaryActionTriggered)
    }

}
