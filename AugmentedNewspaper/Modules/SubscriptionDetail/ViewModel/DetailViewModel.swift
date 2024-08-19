//
//  DetailViewModel.swift
//  AugmentedNewspaper
//
//  Created by Arthur Oliveira on 18/08/24.
//

import Foundation
import Combine

protocol DetailViewModelProtocol {
    func viewDidLoad()

    func fetchSubscriptionPage() async
    var subscriptionPage: SubscriptionPage? { get }
    var subscriptionPagePublisher: Published<SubscriptionPage?>.Publisher { get }

    var selectedOffer: String? { get set }
    var selectedOfferPublisher: Published<String?>.Publisher { get }
    func didTapOffer(_ offer: String)

    var error: String? { get }
    var errorPublisher: Published<String?>.Publisher { get }
}


final class DetailViewModel: DetailViewModelProtocol {
    private let subscriptionService: SubscriptionServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    @Published var subscriptionPage: SubscriptionPage?
    var subscriptionPagePublisher: Published<SubscriptionPage?>.Publisher { $subscriptionPage }

    @Published var selectedOffer: String?
    var selectedOfferPublisher: Published<String?>.Publisher { $selectedOffer }

    @Published var error: String?
    var errorPublisher: Published<String?>.Publisher { $error }

    init(subscriptionService: SubscriptionServiceProtocol = SubscriptionService()) {
        self.subscriptionService = subscriptionService
    }

    func viewDidLoad() {
        Task {
            await fetchSubscriptionPage()
        }
    }

    func fetchSubscriptionPage() async {
        subscriptionPage = nil
        error = nil

        subscriptionService.fetchSubscriptionPage()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.error = "Failed to load subscription page: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] subscriptionPage in
                self?.subscriptionPage = subscriptionPage
            })
            .store(in: &cancellables)
    }

    func didTapOffer(_ offer: String) {
        selectedOffer = offer == selectedOffer ? nil : offer
    }
}
