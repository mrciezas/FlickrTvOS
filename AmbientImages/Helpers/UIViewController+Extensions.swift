//
//  UIViewController+Extensions.swift
//  AmbientImages
//
//  Created by Christian Cieza on 20/09/21.
//

import UIKit

extension UIViewController {

    static func instantiate<T>() -> T {
        guard let storyboardName = String(describing: self).text(before: "ViewController") else {
            fatalError("The controller name is not standard.")
        }
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle(for: self))
        let identifier = String(describing: T.self)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
            fatalError("The storyboard identifier does not exist.")
        }
        return viewController
    }

}
