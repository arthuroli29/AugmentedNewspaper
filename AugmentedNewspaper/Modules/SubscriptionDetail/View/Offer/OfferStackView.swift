//
//  OfferStackView.swift
//  AugmentedNewspaper
//
//  Created by Arthur Oliveira on 18/08/24.
//

import UIKit
import Combine

class OfferStackView: UIStackView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    var onSelect: ((String) -> Void)?

    private func setupUI() {
        axis = .horizontal
        distribution = .fillProportionally
        spacing = 15
    }

    func configure(with offers: [String: Offer], selectedOfferPublisher: AnyPublisher<String?, Never>) {
        arrangedSubviews.forEach { $0.removeFromSuperview() }

        var widthConstrait: NSLayoutDimension?

        for (index, (key, offer)) in offers.enumerated() {
            let offerView = createOfferView(with: offer, id: key, selectedOfferPublisher: selectedOfferPublisher)
            addArrangedSubview(offerView)

            if let widthConstrait = widthConstrait {
                offerView.widthAnchor.constraint(equalTo: widthConstrait).isActive = true
            } else {
                widthConstrait = offerView.widthAnchor
            }

            if index < offers.count - 1 {
                let separator = createSeparatorView()
                addArrangedSubview(separator)
            }
        }
    }

    private func createOfferView(with offer: Offer, id: String, selectedOfferPublisher: AnyPublisher<String?, Never>) -> OfferView {
        let offerView = OfferView()
        offerView.configure(with: offer, id: id)
        offerView.bindSelectedOffer(to: selectedOfferPublisher)
        offerView.onSelect = { [weak self] selectedId in
            self?.onSelect?(selectedId)
        }
        return offerView
    }

    private func createSeparatorView() -> UIView {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.backgroundColor = .separator
        return separator
    }
}
