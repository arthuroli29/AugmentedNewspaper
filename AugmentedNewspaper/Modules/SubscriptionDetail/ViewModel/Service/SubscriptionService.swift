//
//  SubscriptionService.swift
//  AugmentedNewspaper
//
//  Created by Arthur Oliveira on 19/08/24.
//

import Foundation
import Combine

protocol SubscriptionServiceProtocol {
    func fetchSubscriptionPage() -> AnyPublisher<SubscriptionPage, Error>
}

class SubscriptionService: SubscriptionServiceProtocol {
    func fetchSubscriptionPage() -> AnyPublisher<SubscriptionPage, Error> {
        guard let url = URL(string: "https://take-home-task-df69e.web.app/takeHome.json") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: SubscriptionPage.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
