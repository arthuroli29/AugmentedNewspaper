//
//  MockCoreDataService.swift
//  AugmentedNewspaperTests
//
//  Created by Arthur Oliveira on 19/08/24.
//

import Foundation
import Combine
@testable import AugmentedNewspaper

final class MockCoreDataService: CoreDataServiceProtocol {
    var cachedData: Data?

    func fetchCachedSubscriptionPageData() -> Data? {
        return cachedData
    }

    func saveSubscriptionPageData(_ data: Data) {
        cachedData = data
    }
}
