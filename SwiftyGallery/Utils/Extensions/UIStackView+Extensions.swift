//
//  UIStackView+Extensions.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 31/12/23.
//

import UIKit

extension UIStackView {
    func clearArrangedSubviews() {
        arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}
