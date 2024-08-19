//
//  Offer.swift
//  AugmentedNewspaper
//
//  Created by Arthur Oliveira on 19/08/24.
//

import Foundation

class Offer: Codable {
    let price: Double
    let description: String

    init(price: Double, description: String) {
        self.price = price
        self.description = description
    }
}
