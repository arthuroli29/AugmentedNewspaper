//
//  HeaderView.swift
//  AugmentedNewspaper
//
//  Created by Arthur Oliveira on 19/08/24.
//

import UIKit

class HeaderView: UIView {
    private let headerLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "photo")
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .label
        addSubview(headerLogo)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerLogo.centerYAnchor.constraint(equalTo: centerYAnchor),
            headerLogo.centerXAnchor.constraint(equalTo: centerXAnchor),
            headerLogo.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            headerLogo.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
        ])
    }

    private func configure(with image: UIImage) {
        headerLogo.image = image
    }
}
