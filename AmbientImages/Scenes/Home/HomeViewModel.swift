//
//  HomeViewModel.swift
//  AmbientImages
//
//  Created by Christian Cieza on 22/09/21.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject, Identifiable {

    @Published var state: State = .feed

}

extension HomeViewModel {

    enum State: Int {

        case feed = 0
        case search

    }

}
