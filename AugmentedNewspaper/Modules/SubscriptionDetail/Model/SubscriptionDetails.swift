//
//  Subscription.swift
//  AugmentedNewspaper
//
//  Created by Arthur Oliveira on 19/08/24.
//

import Foundation

struct SubscriptionDetails: Codable, Equatable {
    static func == (lhs: SubscriptionDetails, rhs: SubscriptionDetails) -> Bool {
        lhs.offerPageStyle == rhs.offerPageStyle
            && lhs.coverImage == rhs.coverImage
            && lhs.subscribeTitle == rhs.subscribeTitle
            && lhs.subscribeSubtitle == rhs.subscribeSubtitle
            && lhs.offers == rhs.offers
            && lhs.benefits == rhs.benefits
            && lhs.disclaimer == rhs.disclaimer
    }

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
