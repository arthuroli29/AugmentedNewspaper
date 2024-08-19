//
//  CoreDataService.swift
//  AugmentedNewspaper
//
//  Created by Arthur Oliveira on 19/08/24.
//

import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    func saveSubscriptionPageData(_ data: Data)
    func fetchCachedSubscriptionPageData() -> Data?
}

final class CoreDataService: CoreDataServiceProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }

    func saveSubscriptionPageData(_ data: Data) {
        let request = NSFetchRequest<SubscriptionPageEntity>(entityName: "SubscriptionPageEntity")
        if let subscriptionEntity = try? context.fetch(request).first ?? SubscriptionPageEntity(context: context) {
            subscriptionEntity.jsonData = data
            try? context.save()
        }
    }

    func fetchCachedSubscriptionPageData() -> Data? {
        let request = NSFetchRequest<SubscriptionPageEntity>(entityName: "SubscriptionPageEntity")
        request.fetchLimit = 1

        if let subscriptionEntity = try? context.fetch(request).first {
            return subscriptionEntity.jsonData
        }
        return nil
    }
}
