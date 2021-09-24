//
//  URL+Extensions.swift
//  AmbientImages
//
//  Created by Christian Cieza on 23/09/21.
//

import Foundation

extension URL {

    init(_ request: BaseRequest) {
        let allowedChars = CharacterSet.urlPathAllowed.union(.urlQueryAllowed)
        guard let encodedPath = request.path.addingPercentEncoding(withAllowedCharacters: allowedChars) else {
            fatalError("Invalid path: \(request.path)")
        }
        let raw = request.baseUrl.absoluteString + encodedPath
        guard let url = URL(string: raw) else {
            fatalError("Malformed url [0]: \(raw)")
        }
        // Query
        guard let queryItems = request.urlQueryItems, !queryItems.isEmpty else {
            self = url
            return
        }
        guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            fatalError("Malformed url [1]: \(url.absoluteString)")
        }
        components.queryItems = queryItems
        guard let formattedUrl = components.url else {
            fatalError("Malformed url [2]: \(components.string ?? "")")
        }
        self = formattedUrl
    }

}
