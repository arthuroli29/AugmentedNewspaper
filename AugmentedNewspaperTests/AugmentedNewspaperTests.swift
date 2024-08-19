//
//  AugmentedNewspaperTests.swift
//  AugmentedNewspaperTests
//
//  Created by Arthur Oliveira on 17/08/24.
//

import XCTest
import Combine
@testable import AugmentedNewspaper

final class AugmentedNewspaperTests: XCTestCase {
    private var viewModel: DetailViewModel!
    private var mockSubscriptionService: MockSubscriptionService!
    private var mockCoreDataService: MockCoreDataService!
    private var cancellables: Set<AnyCancellable>!

    private var sampleOffer: Offer!
    private var sampleSubscription: SubscriptionDetails!
    private var sampleSubscriptionPage: SubscriptionPage!

    override func setUp() {
        super.setUp()
        mockSubscriptionService = MockSubscriptionService()
        mockCoreDataService = MockCoreDataService()
        viewModel = DetailViewModel(subscriptionService: mockSubscriptionService, coreDataService: mockCoreDataService)
        cancellables = Set<AnyCancellable>()

        sampleOffer = Offer(price: 9.99, description: "Sample Offer")
        sampleSubscription = SubscriptionDetails(
            offerPageStyle: "simple",
            coverImage: "coverImageUrl",
            subscribeTitle: "Subscribe Now",
            subscribeSubtitle: "Limited Time Offer",
            offers: ["offer1": sampleOffer, "offer2": sampleOffer],
            benefits: ["Benefit 1", "Benefit 2"],
            disclaimer: "Terms and conditions apply."
        )
        sampleSubscriptionPage = SubscriptionPage(
            headerLogo: "headerLogoUrl",
            subscription: sampleSubscription
        )
    }

    override func tearDown() {
        cancellables = nil
        viewModel = nil
        mockSubscriptionService = nil
        mockCoreDataService = nil
        sampleOffer = nil
        sampleSubscription = nil
        sampleSubscriptionPage = nil
        super.tearDown()
    }

    func testFetchSubscriptionPage_successful() async {
        // Arrange
        let expectation = XCTestExpectation(description: "Subscription page fetch should succeed")
        mockSubscriptionService.subscriptionPageResult = .success(sampleSubscriptionPage)

        // Act
        await viewModel.fetchSubscriptionPage()

        viewModel.$subscriptionPage
            .dropFirst() // Ignore the initial nil value
            .sink { subscriptionPage in
                // Assert
                XCTAssertEqual(subscriptionPage, self.sampleSubscriptionPage)
                XCTAssertNil(self.viewModel.error)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await fulfillment(of: [expectation], timeout: 2.0)
    }

    func testFetchSubscriptionPage_failure() async {
        // Arrange
        let expectation = XCTestExpectation(description: "Subscription page fetch should fail")
        mockSubscriptionService.subscriptionPageResult = .failure(URLError(.badServerResponse))

        // Act
        await viewModel.fetchSubscriptionPage()

        viewModel.$error
            .dropFirst() // Ignore the initial nil value
            .sink { error in
                // Assert
                XCTAssertEqual(error, "Failed to load subscription page: The operation couldn’t be completed. (NSURLErrorDomain error -1011.)")
                XCTAssertNil(self.viewModel.subscriptionPage)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await fulfillment(of: [expectation], timeout: 2.0)
    }


    func testFetchSubscriptionPage_usesCachedData() async {
        // Arrange
        let cachedData = try? JSONEncoder().encode(sampleSubscriptionPage)
        mockCoreDataService.cachedData = cachedData
        mockSubscriptionService.subscriptionPageResult = .success(sampleSubscriptionPage)

        // Act
        await viewModel.fetchSubscriptionPage()

        // Assert
        XCTAssertEqual(viewModel.subscriptionPage, sampleSubscriptionPage)
        XCTAssertNil(viewModel.error)
    }

    func testDidTapOffer_selectsOffer() {
        // Arrange
        let offer = "offer1"

        // Act
        viewModel.didTapOffer(offer)

        // Assert
        XCTAssertEqual(viewModel.selectedOffer, offer)
    }

    func testDidTapOffer_deselectsOffer() {
        // Arrange
        let offer = "offer1"
        viewModel.selectedOffer = offer

        // Act
        viewModel.didTapOffer(offer)

        // Assert
        XCTAssertNil(viewModel.selectedOffer)
    }
}
