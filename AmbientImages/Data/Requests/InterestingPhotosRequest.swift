//
//  InterestingPhotosRequest.swift
//  AmbientImages
//
//  Created by Christian Cieza on 21/09/21.
//

import Foundation

struct InterestingPhotosRequest: Request {

    typealias Response = PhotosList

    var method: HTTPMethod = .get
    var urlQueryItems: [URLQueryItem]?

    init(perPage: Int? = nil, page: Int? = nil) {
        urlQueryItems = [
            URLQueryItem(name: "method", value: "flickr.interestingness.getList"),
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
