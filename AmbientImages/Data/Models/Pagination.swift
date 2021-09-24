//
//  Pagination.swift
//  AmbientImages
//
//  Created by Christian Cieza on 21/09/21.
//

import Foundation

struct Pagination: Decodable {

    let page: Int
    let pages: Int
    let perPage: Int
    let total: Int

    enum CodingKeys: String, CodingKey {

        case page, pages, total
        case perPage = "perpage"
    }

}

extension Pagination {

    static let photosPerPageGrid = 12

}
