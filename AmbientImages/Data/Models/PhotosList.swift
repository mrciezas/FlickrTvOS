//
//  PhotosList.swift
//  AmbientImages
//
//  Created by Christian Cieza on 22/09/21.
//

import Foundation

struct PhotosList: Decodable {

    let photos: [FlickrPhoto]
    let pagination: Pagination

    init(from decoder: Decoder) throws {
        // Pagination
        let container = try decoder.container(keyedBy: CodingKeys.self)
        pagination = try container.decode(Pagination.self, forKey: .photos)
        // Photos
        let nestedContainer = try container.nestedContainer(keyedBy: NestedCodingKeys.self, forKey: .photos)
        photos = try nestedContainer.decode([FlickrPhoto].self, forKey: .photo)
    }

    enum CodingKeys: String, CodingKey {

        case photos

    }

    enum NestedCodingKeys: String, CodingKey {

        case photo

    }

}
