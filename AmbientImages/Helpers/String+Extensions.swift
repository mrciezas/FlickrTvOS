//
//  String+Extensions.swift
//  AmbientImages
//
//  Created by Christian Cieza on 20/09/21.
//

import Foundation

extension String {

    func text(before text: String) -> String? {
        guard let range = range(of: text) else { return nil }
        return String(self[startIndex..<range.lowerBound])
    }

}
