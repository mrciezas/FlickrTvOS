//
//  Request.swift
//  AmbientImages
//
//  Created by Christian Cieza on 21/09/21.
//

import Foundation

public enum HTTPMethod: String {

    case get = "GET"

}

protocol BaseRequest {

    var baseUrl: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var urlQueryItems: [URLQueryItem]? { get }

}

extension BaseRequest {

    var baseUrl: URL { Enviroment.mainURL }
    var path: String { "" }

}

protocol Request: BaseRequest {

    associatedtype Response

    var decode: (Data) throws -> Response { get }

}

extension Request where Response: Decodable {

    var decode: (Data) throws -> Response {
        return { data in
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            return try decoder.decode(Response.self, from: data)
        }
    }

}
