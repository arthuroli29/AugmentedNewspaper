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
