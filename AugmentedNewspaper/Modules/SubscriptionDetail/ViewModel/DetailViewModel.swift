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

    var subscriptionService: SubscriptionServiceProtocol { get }
    var coreDataService: CoreDataServiceProtocol { get }

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
    let subscriptionService: SubscriptionServiceProtocol
    let coreDataService: CoreDataServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    @Published var subscriptionPage: SubscriptionPage?
    var subscriptionPagePublisher: Published<SubscriptionPage?>.Publisher { $subscriptionPage }

    @Published var selectedOffer: String?
    var selectedOfferPublisher: Published<String?>.Publisher { $selectedOffer }

    @Published var error: String?
    var errorPublisher: Published<String?>.Publisher { $error }

    init(
        subscriptionService: SubscriptionServiceProtocol = SubscriptionService(),
        coreDataService: CoreDataServiceProtocol = CoreDataService()
    ) {
        self.subscriptionService = subscriptionService
        self.coreDataService = coreDataService
    }

    func viewDidLoad() {
        Task {
            await fetchSubscriptionPage()
        }
    }

    func fetchSubscriptionPage() async {
        subscriptionPage = nil
        error = nil

        let cachedSubscriptionPageJson = self.coreDataService.fetchCachedSubscriptionPageData()
        let cachedSubscriptionPage = cachedSubscriptionPageJson
            .flatMap {
                try? JSONDecoder().decode(SubscriptionPage.self, from: $0)
            }

        if let cachedSubscriptionPage {
            self.subscriptionPage = cachedSubscriptionPage
        }

        subscriptionService.fetchSubscriptionPage()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.error = "Failed to load subscription page: \(error.localizedDescription)"
                }
            }, receiveValue: { [weak self] subscriptionPage in
                guard let self = self else { return }

                if cachedSubscriptionPage != subscriptionPage {
                    self.subscriptionPage = subscriptionPage
                    if let newJsonData = try? JSONEncoder().encode(subscriptionPage) {
                        self.coreDataService.saveSubscriptionPageData(newJsonData)
                    }
                }
            })
            .store(in: &cancellables)
    }

    func didTapOffer(_ offer: String) {
        selectedOffer = offer == selectedOffer ? nil : offer
    }
}
