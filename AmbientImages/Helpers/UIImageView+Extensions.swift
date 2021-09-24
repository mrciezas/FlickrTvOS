//
//  UIImageView+Extensions.swift
//  AmbientImages
//
//  Created by Christian Cieza on 23/09/21.
//

import Foundation
import UIKit

extension UIImageView {

    func loadImage(at url: URL, _ completionHandler: ((Result<UIImage, Error>) -> Void)? = nil) {
        UIImageLoader.loader.load(url, for: self, completionHandler)
    }

    func cancelImageLoad() {
        UIImageLoader.loader.cancel(for: self)
    }

}
