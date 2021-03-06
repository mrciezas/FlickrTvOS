//
//  SearchViewModel.swift
//  AmbientImages
//
//  Created by Christian Cieza on 22/09/21.
//

import Foundation

class SearchViewModel: PhotosListViewModel, ObservableObject, Identifiable {

    var title: String {
        guard let text = searchText, !text.isEmpty else { return "" }
        if let pagination = pagination, pagination.total == 0 {
            return StaticText.noSearchResultFor + " \"\(text)\""
        }
        return StaticText.searchResultFor + " \"\(text)\""
    }
    var selectedIndexPath: IndexPath?
    private var searchText: String?
    private(set) var pagination: Pagination?
    @Published private(set) var photos: [FlickrPhoto] = []
    var photosPublisher: Published<[FlickrPhoto]>.Publisher { $photos }
    @Published var mainState: State = .start
    var mainStatePublisher: Published<State>.Publisher { $mainState }

    func loadData() {}

    func loadPage(_ page: Int?) {
        guard let text = searchText else { return }
        mainState = .loading
        let request = SearchPhotosRequest(text: text, perPage: photosPerPage, page: page)
        NetworkSession.shared.load(request) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.mainState = .loaded
                switch result {
                case .success(let response):
                    self.pagination = response.pagination
                    self.photos.append(contentsOf: response.photos)
                case .failure(let error):
                    self.mainState = .failed(error)
                }
            }
        }
    }

    func search(with text: String?) {
        guard let text = text, !text.isEmpty else { return }
        self.searchText = text
        self.pagination = nil
        self.photos = []
        loadPage(0)
    }

}
