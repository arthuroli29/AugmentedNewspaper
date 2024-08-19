//
//  SubscriptionPage.swift
//  AugmentedNewspaper
//
//  Created by Arthur Oliveira on 18/08/24.
//

import Foundation

struct SubscriptionPage: Codable, Equatable {
    static func == (lhs: SubscriptionPage, rhs: SubscriptionPage) -> Bool {
        lhs.headerLogo == rhs.headerLogo
            && lhs.subscription == rhs.subscription
    }

    let headerLogo: String
    let subscription: SubscriptionDetails

    enum CodingKeys: String, CodingKey {
        case headerLogo = "header_logo"
        case subscription
    }
}
