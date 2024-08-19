//
//  HeaderView.swift
//  AugmentedNewspaper
//
//  Created by Arthur Oliveira on 19/08/24.
//

import UIKit

class HeaderView: UIView {
    let logoView: LoadingImageView = {
        let imageView = LoadingImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
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
        addSubview(logoView)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            logoView.centerYAnchor.constraint(equalTo: centerYAnchor),
            logoView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            logoView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
        ])
    }

    func configure(with image: UIImage) {
        logoView.image = image
    }
}
