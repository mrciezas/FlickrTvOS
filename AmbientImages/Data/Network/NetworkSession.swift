//
//  NetworkSession.swift
//  AmbientImages
//
//  Created by Christian Cieza on 21/09/21.
//

import Foundation

class NetworkSession {

    static let shared: NetworkSession = NetworkSession()

    private let session: URLSession

    private init() {
        let configuration: URLSessionConfiguration = .default
        session = URLSession(configuration: configuration)
    }

    @discardableResult
    func load<R: Request>(
        _ request: R,
        completion: @escaping (Result<R.Response, Error>) -> Void
    ) -> URLSessionDataTask {
        let urlRequest = URLRequest(request)
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                return completion(.failure(error))
            }
            guard let response = response as? HTTPURLResponse else {
                return completion(.failure(AmbError.customMessageError(message: "Invalid response")))
            }
            if (200...299).contains(response.statusCode), let data = data {
                print(String(data: data, encoding: .utf8) ?? "")
                let decodeResult = Result { try request.decode(data) }
                completion(decodeResult)
            } else {
                completion(.failure(AmbError.requestError))
            }
        }
        task.resume()
        return task
    }

}
