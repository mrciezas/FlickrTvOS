//
//  AmbError.swift
//  AmbientImages
//
//  Created by Christian Cieza on 23/09/21.
//

import Foundation

enum AmbError: Error {

    case requestError
    case customMessageError(message: String)

    var localizedDescription: String {
        switch self {
        case .requestError: return StaticText.somethingHappened
        case .customMessageError(let message): return message
        }
    }

}
