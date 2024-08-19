//
//  CircleButton.swift
//  AugmentedNewspaper
//
//  Created by Arthur Oliveira on 18/08/24.
//

import UIKit

class CircleButton: UIView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage.icCheckmark.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .systemBackground
        return imageView
    }()

    var isSelected: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.updateImage()
            }
        }
    }

    var onTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        layer.cornerRadius = 32 / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
        backgroundColor = .systemGray6

        addSubview(imageView)
        updateImage()

        setupConstraints()
        setupGestures()
    }

    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
        addGestureRecognizer(tapGesture)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 32),
            heightAnchor.constraint(equalToConstant: 32),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5)
        ])
    }

    private func updateImage() {
        self.backgroundColor = self.isSelected ? .label : .systemGray6
        self.layer.borderColor = self.isSelected ? UIColor.label.cgColor : UIColor.systemGray4.cgColor
        self.imageView.isHidden = !self.isSelected
    }

    @objc private func didTap() {
        onTap?()
    }
}
