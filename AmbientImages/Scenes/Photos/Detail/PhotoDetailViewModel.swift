//
//  PhotoDetailViewModel.swift
//  AmbientImages
//
//  Created by Christian Cieza on 22/09/21.
//

import Foundation
import UIKit
import Combine

class PhotoDetailViewModel: ObservableObject, Identifiable {

    typealias ImageInfo = (image: UIImage, aspectRatio: Double)

    private var photos: [FlickrPhoto]
    private var selectedIndexPath: IndexPath
    @Published var state: State = .start
    @Published var currentImageInfo: (image: UIImage, aspectRatio: Double)?
    private var imageLoadTask: [URL: IndexPath] = [:]
    var passCurrentIndexPath: PassthroughSubject<IndexPath, Never> = PassthroughSubject<IndexPath, Never>()

    init(_ photos: [FlickrPhoto], selectedIndexPath: IndexPath) {
        self.photos = photos
        self.selectedIndexPath = selectedIndexPath
    }

    func loadData() {
        loadImage()
    }

    func changePhoto(on direction: Direction) {
        switch direction {
        case .left:
            selectedIndexPath.row = min(photos.count - 1, selectedIndexPath.row + 1)
        case .right:
            selectedIndexPath.row = max(0, selectedIndexPath.row - 1)
        }
        loadImage()
        passCurrentIndexPath.send(selectedIndexPath)
    }

    func reloadImage() {
        loadImage()
    }

    private func loadImage() {
        state = .loading
        let photo = photos[selectedIndexPath.row]
        let url = photo.originalURL ?? photo.thumbnailURL
        let aspectRatio = photo.originalAspectRadio ?? photo.thumbnailAspectRadio
        imageLoadTask[url] = selectedIndexPath
        _ = ImageLoader.shared.loadImage(url) { (result) in
            self.state = .loaded
            switch result {
            case .success(let image):
                guard let indexPath = self.imageLoadTask[url] else { return }
                if indexPath == self.selectedIndexPath {
                    self.currentImageInfo = (image: image, aspectRatio: aspectRatio)
                }
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }

}

extension PhotoDetailViewModel {

    enum Direction {

        case left, right

        init?(_ uiDirection: UISwipeGestureRecognizer.Direction) {
            switch uiDirection {
            case .left: self = .left
            case .right: self = .right
            default: return nil
            }
        }

    }
    
}
