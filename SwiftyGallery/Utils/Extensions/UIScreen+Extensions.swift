//
//  UIScreen+Extension.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 01/12/23.
//

import UIKit

extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}
