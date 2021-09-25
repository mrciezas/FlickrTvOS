//
//  ImageRequest.swift
//  AmbientImages
//
//  Created by Christian Cieza on 21/09/21.
//

import Foundation
import UIKit

struct ImageRequest: Request {

    public typealias Response = UIImage

    let baseUrl: URL
    let method: HTTPMethod = .get
    let urlQueryItems: [URLQueryItem]? = []
    var decode: (Data) throws -> Response { customDecode }

    public init(url: URL) {
        baseUrl = url
    }

    private func customDecode(data: Data) throws -> Response {
        guard let image = UIImage(data: data) else {
            throw AmbError.customMessageError(message: "Error decoding image")
        }
        return image
    }

}
