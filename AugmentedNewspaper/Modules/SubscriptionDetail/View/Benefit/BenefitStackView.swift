//
//  BenefitStackView.swift
//  AugmentedNewspaper
//
//  Created by Arthur Oliveira on 19/08/24.
//

import UIKit

class BenefitStackView: UIStackView {
    private let titleStackView: UIStackView = {
        let titleStackView = UIStackView()
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.backgroundColor = .systemBackground
        titleStackView.axis = .horizontal
        titleStackView.spacing = 8
        return titleStackView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "What is \"News+\"?"
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()

    private let arrowImageView: UIImageView = {
        let arrowImageView = UIImageView(image: UIImage.icArrowDown.withRenderingMode(.alwaysTemplate))
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.tintColor = .label
        return arrowImageView
    }()

    private let benefitsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()

    private var isCollapsed = true {
        didSet {
            UIView.animate(withDuration: 0.3) {
                self.configureCollapse()
            }
        }
    }

    private func configureCollapse() {
        arrowImageView.transform = isCollapsed ?
        CGAffineTransform(rotationAngle: .pi * 2) :
        CGAffineTransform(rotationAngle: -.pi)

        benefitsStackView.alpha = isCollapsed ? 0 : 1
        benefitsStackView.isHidden = isCollapsed
    }

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
        alignment = .center
        spacing = 15

        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(arrowImageView)

        addArrangedSubview(titleStackView)
        addArrangedSubview(benefitsStackView)

        setupConstraints()
        setupGestures()
        configureCollapse()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            arrowImageView.widthAnchor.constraint(equalToConstant: 16),
            arrowImageView.heightAnchor.constraint(equalToConstant: 16),
        ])
    }

    private func setupGestures() {
        titleStackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapTitle)))
    }

    @objc private func didTapTitle() {
        isCollapsed.toggle()
    }

    func configure(with benefits: [String]) {
        benefitsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        benefits.forEach { benefit in
            let benefitView = BenefitView(benefit: benefit)
            benefitsStackView.addArrangedSubview(benefitView)
            benefitView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        }
    }
}
