//
//  BenefitView.swift
//  AugmentedNewspaper
//
//  Created by Arthur Oliveira on 19/08/24.
//

import UIKit

final class BenefitView: UIStackView {
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    init(benefit: String) {
        super.init(frame: .zero)
        setupUI()
        configure(with: benefit)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        axis = .horizontal
        alignment = .center
        spacing = 15

        let circleView = createCircleView()

        addArrangedSubview(circleView)
        addArrangedSubview(label)
    }

    private func createCircleView() -> UIView {
        let circleView = UIView()
        circleView.widthAnchor.constraint(equalToConstant: 10).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        circleView.layer.cornerRadius = 10 / 2
        circleView.clipsToBounds = true
        circleView.backgroundColor = .appBlueLight
        return circleView
    }

    func configure(with benefit: String) {
        label.text = benefit
    }
}
