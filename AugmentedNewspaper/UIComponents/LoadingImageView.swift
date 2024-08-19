//
//  LoadingImageView.swift
//  AugmentedNewspaper
//
//  Created by Arthur Oliveira on 19/08/24.
//

import UIKit

class LoadingImageView: UIImageView {
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        addSubview(activityIndicator)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    @MainActor
    func loadImage(from url: URL) async {
        activityIndicator.startAnimating()
        defer { activityIndicator.stopAnimating() }
        await load(url: url)
    }

    @MainActor
    func loadImage(from urlString: String) async {
        guard let url = URL(string: urlString) else {
            return
        }
        await loadImage(from: url)
    }
}
