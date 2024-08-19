//
//  Offer.swift
//  AugmentedNewspaper
//
//  Created by Arthur Oliveira on 19/08/24.
//

import Foundation

class Offer: Codable, Equatable {
    static func == (lhs: Offer, rhs: Offer) -> Bool {
        lhs.price == rhs.price
            && lhs.description == rhs.description
    }

    let price: Double
    let description: String

    init(price: Double, description: String) {
        self.price = price
        self.description = description
    }
}
