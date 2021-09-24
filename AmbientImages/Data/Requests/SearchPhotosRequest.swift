//
//  SearchPhotosRequest.swift
//  AmbientImages
//
//  Created by Christian Cieza on 22/09/21.
//

import Foundation

struct SearchPhotosRequest: Request {

    typealias Response = PhotosList

    let path: String = "services/rest/"
    var method: HTTPMethod = .get
    var urlQueryItems: [URLQueryItem]?

    init(text: String, perPage: Int? = nil, page: Int? = nil) {
        urlQueryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "text", value: text),
            URLQueryItem(name: "extras", value: "date_upload,owner_name,url_q,url_o")
        ]
        urlQueryItems?.append(contentsOf: URLQueryItem.flickrDefaultItems())
        if let perPage = perPage {
            urlQueryItems?.append(URLQueryItem(name: "per_page", value: "\(perPage)"))
        }
        if let page = page {
            urlQueryItems?.append(URLQueryItem(name: "page", value: "\(page)"))
        }
    }

}
