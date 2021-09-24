//
//  FlickrDefaulQueryItems.swift
//  AmbientImages
//
//  Created by Christian Cieza on 23/09/21.
//

import Foundation

extension URLQueryItem {

    static func flickrDefaultItems() -> [URLQueryItem] {
        [
            URLQueryItem(name: "api_key", value: Enviroment.apiKey),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1")
        ]
    }

}
