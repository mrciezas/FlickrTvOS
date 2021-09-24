//
//  UIView+Extensions.swift
//  AmbientImages
//
//  Created by Christian Cieza on 20/09/21.
//

import UIKit

extension UIView {

    static func configure<T>(_ value: T, with closure: (inout T) -> Void) -> T {
        var value = value
        closure(&value)
        return value
    }

    func pinToSuperView(_ insets: NSDirectionalEdgeInsets = .zero) {
        guard let superview = superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.leading),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.trailing),
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom)
        ])
    }

}
