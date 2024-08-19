//
//  Subscription.swift
//  AugmentedNewspaper
//
//  Created by Arthur Oliveira on 19/08/24.
//

import Foundation

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
