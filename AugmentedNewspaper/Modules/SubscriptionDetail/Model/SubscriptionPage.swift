//
//  SubscriptionPage.swift
//  AugmentedNewspaper
//
//  Created by Arthur Oliveira on 18/08/24.
//

import Foundation

struct SubscriptionPage: Codable {
    let headerLogo: String
    let subscription: Subscription

    enum CodingKeys: String, CodingKey {
        case headerLogo = "header_logo"
        case subscription
    }
}

struct Subscription: Codable {
    let offerPageStyle: String
    let coverImage: String
    let subscribeTitle: String
    let subscribeSubtitle: String
    let offers: [String: Offer]
    let benefits: [String]
    let disclaimer: String

    enum CodingKeys: String, CodingKey {
        case offerPageStyle = "offer_page_style"
        case coverImage = "cover_image"
        case subscribeTitle = "subscribe_title"
        case subscribeSubtitle = "subscribe_subtitle"
        case offers
        case benefits
        case disclaimer
    }
}

class Offer: Codable {
    let price: Double
    let description: String

    init(price: Double, description: String) {
        self.price = price
        self.description = description
    }
}
