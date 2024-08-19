//
//  MockSubscriptionService.swift
//  AugmentedNewspaperTests
//
//  Created by Arthur Oliveira on 19/08/24.
//

import Foundation
import Combine
@testable import AugmentedNewspaper

final class MockSubscriptionService: SubscriptionServiceProtocol {
    var subscriptionPageResult: Result<SubscriptionPage, Error>?

    func fetchSubscriptionPage() -> AnyPublisher<SubscriptionPage, Error> {
        if let result = subscriptionPageResult {
            return result.publisher.eraseToAnyPublisher()
        } else {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
    }
}
