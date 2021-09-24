//
//  ImageLoader.swift
//  AmbientImages
//
//  Created by Christian Cieza on 21/09/21.
//

import UIKit

class ImageLoader {

    static let shared = ImageLoader()

    private var cache = NSCache<NSString, UIImage>()
    private var runningRequests = [UUID: URLSessionDataTask]()

    func loadImage(_ url: URL, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        if let image = cache.object(forKey: NSString(string: url.absoluteString)) {
            completion(.success(image))
            return nil
        }
        let uuid = UUID()
        let request = ImageRequest(url: url)
        let task = NetworkSession.shared.load(request) { (result) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                defer { self.runningRequests.removeValue(forKey: uuid) }
                switch result {
                case .success(let image):
                    self.cache.setObject(image, forKey: NSString(string: String(describing: url)))
                    completion(.success(image))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        runningRequests[uuid] = task
        return uuid
    }

    func cancelLoad(_ uuid: UUID) {
      runningRequests[uuid]?.cancel()
      runningRequests.removeValue(forKey: uuid)
    }

}

class UIImageLoader {

    static let loader = UIImageLoader()

    private let imageLoader = ImageLoader.shared
    private var uuidMap = [UIImageView: UUID]()

    private init() {}

    func load(_ url: URL, for imageView: UIImageView, _ completionHandler: ((Result<UIImage, Error>) -> Void)? = nil) {
        let token = imageLoader.loadImage(url) { result in
            defer { self.uuidMap.removeValue(forKey: imageView) }
            DispatchQueue.main.async {
                switch result {
                case .success(let image): imageView.image = image
                case .failure: break
                }
                completionHandler?(result)
            }
        }
        if let token = token {
            uuidMap[imageView] = token
        }
    }

    func cancel(for imageView: UIImageView) {
        if let uuid = uuidMap[imageView] {
            imageLoader.cancelLoad(uuid)
            uuidMap.removeValue(forKey: imageView)
        }
    }

}
