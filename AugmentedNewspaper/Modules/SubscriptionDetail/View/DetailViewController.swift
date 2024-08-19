//
//  ViewController.swift
//  AugmentedNewspaper
//
//  Created by Arthur Oliveira on 17/08/24.
//

import UIKit
import Combine

class DetailViewController: UIViewController {
    init(viewModel: DetailViewModelProtocol = DetailViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var viewModel: DetailViewModelProtocol

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .systemBackground
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()

    private let headerView: HeaderView = {
        let view = HeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()

    private let subscribeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        label.textAlignment = .center
        label.text = "Get Unlimited Access"
        return label
    }()

    private let subscribeSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "STLToday.com is where your story lives. Stay in the loop with unlimited access to articles, videos, and the E-edition."
        return label
    }()

    private lazy var offerStackView: OfferStackView = {
        let stackView = OfferStackView()
        stackView.configure(
            with: viewModel.offers,
            selectedOfferPublisher: viewModel.selectedOfferPublisher.eraseToAnyPublisher()
        )
        stackView.onSelect = { [weak self] selectedOffer in
            self?.viewModel.didTapOffer(selectedOffer)
        }
        return stackView
    }()

    private lazy var benefitsLabel: BenefitStackView = {
        let benefitsView = BenefitStackView()
        benefitsView.configure(with: viewModel.benefits)
        return benefitsView
    }()

    private let subscribeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Subscribe Now", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .appBlue
        button.tintColor = .white
        button.layer.cornerRadius = 4
        return button
    }()

    private let disclaimerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "By starting your subscription, you agree to our Terms and Conditions and Privacy Policy."
        return label
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .label

        view.addSubview(headerView)
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        stackView.addArrangedSubview(coverImageView)
        stackView.addArrangedSubview(SpacerView(size: 20))
        stackView.addArrangedSubview(subscribeTitleLabel)
        stackView.addArrangedSubview(SpacerView(size: 20))
        stackView.addArrangedSubview(subscribeSubtitleLabel)
        stackView.addArrangedSubview(SpacerView(size: 25))
        stackView.addArrangedSubview(offerStackView)
        stackView.addArrangedSubview(SpacerView(size: 30))
        stackView.addArrangedSubview(benefitsLabel)
        stackView.addArrangedSubview(SpacerView(size: 50))
        stackView.addArrangedSubview(subscribeButton)
        stackView.addArrangedSubview(SpacerView(size: 20))
        stackView.addArrangedSubview(disclaimerLabel)

        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),

            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),

            stackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40),

            coverImageView.heightAnchor.constraint(equalToConstant: 150),

            subscribeButton.heightAnchor.constraint(equalToConstant: 50),

            coverImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.8),
            subscribeTitleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            subscribeSubtitleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            offerStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.9),
            benefitsLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.85),
            subscribeButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            disclaimerLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.8),
        ])
    }
}
