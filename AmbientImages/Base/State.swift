//
//  State.swift
//  AmbientImages
//
//  Created by Christian Cieza on 23/09/21.
//

import Foundation

enum State {

    case start
    case loading
    case loaded
    case failed(Error)

    var isFailed: Bool {
        switch self {
        case .failed: return true
        default: return false
        }
    }

}
