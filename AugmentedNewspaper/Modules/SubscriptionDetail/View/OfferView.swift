//
//  OfferView.swift
//  AugmentedNewspaper
//
//  Created by Arthur Oliveira on 18/08/24.
//

import UIKit
import Combine

class OfferView: UIStackView {
    private var id: String?
    private var cancellables = Set<AnyCancellable>()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.textAlignment = .center
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()

    private let circleButton = CircleButton()

    var onSelect: ((String) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        axis = .vertical
        spacing = 8
        alignment = .center

        addArrangedSubview(priceLabel)
        addArrangedSubview(descriptionLabel)
        addArrangedSubview(circleButton)

        setupGestures()
    }

    private func setupGestures() {
        circleButton.onTap = { [weak self] in
            guard let self, let id = self.id else { return }
            self.onSelect?(id)
        }
    }

    func bindSelectedOffer(to selectedOfferPublisher: AnyPublisher<String?, Never>) {
        selectedOfferPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] selectedOffer in
                guard let self = self else { return }
                self.circleButton.isSelected = selectedOffer == self.id
            }
            .store(in: &cancellables)
    }

    func configure(with offer: Offer, id: String) {
        self.id = id
        priceLabel.text = String(format: "$%.2f", offer.price)
        descriptionLabel.text = offer.description
    }
}
