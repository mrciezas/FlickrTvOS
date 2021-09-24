//
//  URLRequest+Extensions.swift
//  AmbientImages
//
//  Created by Christian Cieza on 23/09/21.
//

import Foundation

extension URLRequest {

    init(_ request: BaseRequest) {
        let url = URL(request)
        self.init(url: url)
        httpMethod = request.method.rawValue
    }

}
