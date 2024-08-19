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
    private var cancellables = Set<AnyCancellable>()

    private var isLoading = true {
        didSet {
            configureLoading()
        }
    }

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

    private let coverImageView: LoadingImageView = {
        let imageView = LoadingImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let subscribeTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        label.textAlignment = .center
        return label
    }()

    private let subscribeSubtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var offerStackView = OfferStackView()

    private lazy var benefitsStack = BenefitStackView()

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

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        bindViewModel()
        viewModel.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = .label

        view.addSubview(headerView)
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        setupStackView()
        setupConstraints()
        setupGestures()

        configureLoading()
    }

    private func setupStackView() {
        stackView.addArrangedSubview(coverImageView)
        stackView.addArrangedSubview(SpacerView(size: 20))
        stackView.addArrangedSubview(subscribeTitleLabel)
        stackView.addArrangedSubview(SpacerView(size: 20))
        stackView.addArrangedSubview(subscribeSubtitleLabel)
        stackView.addArrangedSubview(SpacerView(size: 25))
        stackView.addArrangedSubview(offerStackView)
        stackView.addArrangedSubview(SpacerView(size: 30))
        stackView.addArrangedSubview(benefitsStack)
        stackView.addArrangedSubview(SpacerView(size: 50))
        stackView.addArrangedSubview(subscribeButton)
        stackView.addArrangedSubview(SpacerView(size: 20))
        stackView.addArrangedSubview(disclaimerLabel)
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
            benefitsStack.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.85),
            subscribeButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            disclaimerLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 0.8),
        ])
    }

    private func setupGestures() {
        offerStackView.onSelect = { [weak self] selectedOffer in
            self?.viewModel.didTapOffer(selectedOffer)
        }
    }

    private func configureLoading() {
        stackView.isHidden = isLoading
        if isLoading {
            view.addSubview(loadingIndicator)
            NSLayoutConstraint.activate([
                loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ])
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
            loadingIndicator.removeFromSuperview()
        }
    }

    private func bindViewModel() {
        viewModel.subscriptionPagePublisher
            .compactMap { $0 }
            .sink { [weak self] subscriptionPage in
                self?.configure(with: subscriptionPage)
                self?.isLoading = false
            }
            .store(in: &cancellables)

        viewModel.errorPublisher
            .compactMap { $0 }
            .sink { [weak self] errorMessage in
                self?.showErrorAlert(message: errorMessage)
            }
            .store(in: &cancellables)
    }

    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            Task {
                await self?.viewModel.fetchSubscriptionPage()
            }
        })
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }


    func configure(with subscriptionPage: SubscriptionPage) {
        Task {
            await headerView.logoView.loadImage(from: subscriptionPage.headerLogo)
        }
        configure(with: subscriptionPage.subscription)
    }

    private func configure(with subscription: Subscription) {
        Task {
            await coverImageView.loadImage(from: subscription.coverImage)
        }
        subscribeTitleLabel.text = subscription.subscribeTitle
        subscribeSubtitleLabel.text = subscription.subscribeSubtitle
        offerStackView.configure(
            with: subscription.offers,
            selectedOfferPublisher: viewModel.selectedOfferPublisher.eraseToAnyPublisher()
        )
        benefitsStack.configure(with: subscription.benefits)
        disclaimerLabel.text = subscription.disclaimer
    }
}
