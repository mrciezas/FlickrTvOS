//
//  PhotosListViewModel.swift
//  AmbientImages
//
//  Created by Christian Cieza on 22/09/21.
//

import Foundation

protocol PhotosListViewModel: AnyObject {

    var title: String { get }
    var pagination: Pagination? { get }
    var numberOfItems: Int { get }
    var photosPerPage: Int { get }
    var selectedIndexPath: IndexPath? { get set }

    // MARK: - Published

    var photos: [FlickrPhoto] { get }
    var photosPublisher: Published<[FlickrPhoto]>.Publisher { get }

    var mainState: State { get set }
    var mainStatePublisher: Published<State>.Publisher { get }

    // MARK: - Functions

    func loadData()
    func loadPage(_ page: Int?)
    func loadNextPage()
    func retryLoadPage()

}

extension PhotosListViewModel {

    var numberOfItems: Int {
        guard let pagination = pagination else { return 0 }
        if pagination.total == photos.count { return photos.count }
        return photos.count + 1
    }

    var photosPerPage: Int { Pagination.photosPerPageGrid }

    func loadData() {}

    func loadNextPage() {
        guard let pagination = pagination else { return }
        let nextPage = pagination.page + 1
        if nextPage < pagination.pages {
            loadPage(nextPage)
        }
    }

    func retryLoadPage() {
        switch mainState {
        case .failed:
            pagination == nil ? loadPage(0) : loadNextPage()
        default: break
        }
    }

}
