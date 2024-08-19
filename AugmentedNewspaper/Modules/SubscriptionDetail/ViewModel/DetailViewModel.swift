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
}

final class DetailViewModel: DetailViewModelProtocol {
    @Published var selectedOffer: String?
    var selectedOfferPublisher: Published<String?>.Publisher { $selectedOffer }
}
