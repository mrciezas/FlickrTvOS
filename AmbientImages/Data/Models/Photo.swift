//
//  Photo.swift
//  AmbientImages
//
//  Created by Christian Cieza on 21/09/21.
//

import Foundation

struct FlickrPhoto: Decodable {

    let identifier: String
    let title: String
    let server: String
    let ownerName: String
    let thumbnailURLString: String
    private let thumbnailHeight: Int
    private let thumbnailWidth: Int
    private let originalURLString: String?
    private let originalHeight: Int?
    private let originalWidth: Int?
    private let uploadDateString: String

    var uploadDate: Date { Date(timeIntervalSince1970: Double(uploadDateString)!)}
    var thumbnailAspectRadio: Double { Double(thumbnailHeight)/Double(thumbnailWidth) }
    var originalURL: URL? {
        guard let originalURLString = originalURLString else { return nil }
        return URL(string: originalURLString)
    }
    var originalAspectRadio: Double? {
        guard let originalHeight = originalHeight,
              let originalWidth = originalWidth
        else { return nil }
        return Double(originalHeight)/Double(originalWidth)
    }

    enum CodingKeys: String, CodingKey {

        case title, server
        case identifier = "id"
        case uploadDateString = "dateupload"
        case ownerName = "ownername"
        case thumbnailURLString = "url_q"
        case thumbnailHeight = "height_q"
        case thumbnailWidth = "width_q"
        case originalURLString = "url_o"
        case originalHeight = "height_o"
        case originalWidth = "width_o"

    }

}
