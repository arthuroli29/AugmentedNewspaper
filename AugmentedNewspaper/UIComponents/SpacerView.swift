//
//  SpacerView.swift
//  AugmentedNewspaper
//
//  Created by Arthur Oliveira on 19/08/24.
//

import UIKit

open class SpacerView: UIView {
    private var size: CGFloat = 20 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    init(size: CGFloat) {
        super.init(frame: .zero)
        self.size = size
        backgroundColor = .clear
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override var intrinsicContentSize: CGSize { CGSize(width: size, height: size) }
}
