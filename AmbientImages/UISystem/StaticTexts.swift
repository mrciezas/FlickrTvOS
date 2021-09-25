//
//  StaticTexts.swift
//  AmbientImages
//
//  Created by Christian Cieza on 24/09/21.
//

import Foundation

enum StaticText {

    static let retry = "retry".localized
    static let noSearchResultFor = "no_search_result_for".localized
    static let searchResultFor = "search_result_for".localized
    static let trendinNowOnFlickr = "trending_now_on_flickr".localized
    static let invalidResponse = "invalid_response".localized
    static let somethingHappened = "something_happened".localized

}

extension String {

    var localized: String {
        NSLocalizedString(self, comment: " ")
    }

}
