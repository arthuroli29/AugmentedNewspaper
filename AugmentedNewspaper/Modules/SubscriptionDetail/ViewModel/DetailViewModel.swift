//
//  DetailViewModel.swift
//  AugmentedNewspaper
//
//  Created by Arthur Oliveira on 18/08/24.
//

import Foundation
import Combine

protocol DetailViewModelProtocol {
    var selectedOffer: String? { get set }
    var selectedOfferPublisher: Published<String?>.Publisher { get }
    var offers: [String: Offer] { get }
    var benefits: [String] { get }
    func didTapOffer(_ offer: String)
}

final class DetailViewModel: DetailViewModelProtocol {
    var offers: [String: Offer] = [
        "1": Offer(price: 35.99, description: "Billed monthly. Renews on MM/DD/YY."),
        "2": Offer(price: 25.99, description: "Billed anually. Renews on MM/DD/YY."),
    ]

    var benefits: [String] = [
        "Benefit 1",
        "Benefit 2",
        "Benefit 3",
    ]

    @Published var selectedOffer: String?
    var selectedOfferPublisher: Published<String?>.Publisher { $selectedOffer }
    func didTapOffer(_ offer: String) {
        selectedOffer = offer == selectedOffer ? nil : offer
    }
}
