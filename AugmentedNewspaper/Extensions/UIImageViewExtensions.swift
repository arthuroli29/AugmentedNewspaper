//
//  UIImageViewExtensions.swift
//  AugmentedNewspaper
//
//  Created by Arthur Oliveira on 19/08/24.
//

import UIKit

extension UIImageView {
    @MainActor
    func load(url: URL) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else {
                throw NSError(domain: "Invalid image data", code: 0, userInfo: nil)
            }
            self.image = image
        } catch {
            print(error.localizedDescription)
        }
    }

    @MainActor
    func load(urlString: String) async {
        guard let url = URL(string: urlString) else {
            return
        }
        await load(url: url)
    }
}
