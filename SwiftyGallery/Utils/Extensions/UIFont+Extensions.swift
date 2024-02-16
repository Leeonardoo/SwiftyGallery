//
//  UIFont+Extensions.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 01/10/23.
//

import UIKit

extension UIFont {
    
    class func preferredFont(forTextStyle style: UIFont.TextStyle, weight: Weight = .regular, size: CGFloat? = nil) -> UIFont {
        let metrics = UIFontMetrics(forTextStyle: style)
        let descriptor = preferredFont(forTextStyle: style).fontDescriptor
        let defaultSize = descriptor.pointSize
        let fontToScale = UIFont.systemFont(ofSize: size ?? defaultSize, weight: weight)

        return metrics.scaledFont(for: fontToScale)
    }
    
}
