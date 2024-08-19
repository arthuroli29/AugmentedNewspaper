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
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let headerView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()

    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .lightGray
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
        label.text = "STLToday.com is where your story lives. Stay in the loop with unlimited access to articles, videos, and the E-edition. STLToday.com is where your story lives. Stay in the loop with unlimited access to articles, videos, and the E-edition."
        return label
    }()

    private lazy var offerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 30

        let offer1 = OfferView()
        offer1.configure(with: Offer(price: 29.99, description: "Billed monthly. Renews on MM/DD/YY."), id: "abc")
        let offer2 = OfferView()
        offer2.configure(with: Offer(price: 49.99, description: "Billed annually."), id: "def")

        [offer1, offer2].forEach {
            $0.bindSelectedOffer(to: viewModel.selectedOfferPublisher.eraseToAnyPublisher())
            $0.onSelect = { [weak self] id in
                self?.viewModel.selectedOffer = id
            }
            stackView.addArrangedSubview($0)
        }

        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
        separator.backgroundColor = .separator

        stackView.addSubview(separator)
        separator.centerYAnchor.constraint(equalTo: stackView.centerYAnchor).isActive = true
        separator.centerXAnchor.constraint(equalTo: stackView.centerXAnchor).isActive = true
        separator.heightAnchor.constraint(equalTo: stackView.heightAnchor).isActive = true

        return stackView
    }()

    private let benefitsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "What is \"News+\"?"
        return label
    }()

    private let subscribeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Subscribe Now", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 5
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
        stackView.spacing = 20
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(headerView)
        contentView.addSubview(stackView)

        stackView.addArrangedSubview(coverImageView)
        stackView.addArrangedSubview(subscribeTitleLabel)
        stackView.addArrangedSubview(subscribeSubtitleLabel)
        stackView.addArrangedSubview(offerStackView)
        stackView.addArrangedSubview(benefitsLabel)
        stackView.addArrangedSubview(subscribeButton)
        stackView.addArrangedSubview(disclaimerLabel)

        setUpConstraints()
    }

    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            headerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),

            stackView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            coverImageView.heightAnchor.constraint(equalToConstant: 150),

            subscribeButton.heightAnchor.constraint(equalToConstant: 50),

            coverImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.8),
            subscribeTitleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            subscribeSubtitleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            offerStackView.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.9),
            benefitsLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.9),
            subscribeButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            disclaimerLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.8)
        ])
    }
}
