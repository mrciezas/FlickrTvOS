//
//  NSDirectionalEdgeInsets+Extensions.swift
//  AmbientImages
//
//  Created by Christian Cieza on 21/09/21.
//

import Foundation
import UIKit

extension NSDirectionalEdgeInsets {

    init(sameValue: CGFloat) {
        self.init(top: sameValue, leading: sameValue, bottom: sameValue, trailing: sameValue)
    }

}
