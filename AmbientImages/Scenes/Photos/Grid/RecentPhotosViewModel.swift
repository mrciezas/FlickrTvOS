//
//  RecentPhotosViewModel.swift
//  AmbientImages
//
//  Created by Christian Cieza on 21/09/21.
//

import Foundation
import Combine

class RecentPhotosViewModel: PhotosListViewModel {

    let title: String = StaticText.trendinNowOnFlickr
    var selectedIndexPath: IndexPath?
    private(set) var pagination: Pagination?
    @Published private(set) var photos: [FlickrPhoto] = []
    var photosPublisher: Published<[FlickrPhoto]>.Publisher { $photos }
    @Published var mainState: State = .start
    var mainStatePublisher: Published<State>.Publisher { $mainState }

    func loadData() {
        loadPage()
    }

    func loadPage(_ page: Int? = nil) {
        mainState = .loading
        let request = InterestingPhotosRequest(perPage: photosPerPage, page: page)
        NetworkSession.shared.load(request) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    self.mainState = .loaded
                    self.pagination = response.pagination
                    self.photos.append(contentsOf: response.photos)
                case .failure(let error):
                    self.mainState = .failed(error)
                }
            }
        }
    }

}

extension FlickrPhoto: ImageCellModel {

    var subtitle: String {
        let date: DateFormatter = .init()
        date.dateStyle = .medium
        return "\(ownerName) / \(date.string(from: uploadDate))"
    }

    var thumbnailURL: URL { URL(string: thumbnailURLString)! }

}
