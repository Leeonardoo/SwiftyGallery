//
//  NSMutableAttributedStrings+Extensions.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 21/08/23.
//

import Foundation
import UIKit

extension NSMutableAttributedString {
    
    /// Creates a new ``Foundation/NSMutableAttributedString`` with the given format and arguments.
    ///
    /// - Parameters:
    ///  - format: The template string
    ///  - args: The arguments to replace the template
    ///
    ///  Usage:
    /// ````swift
    /// let template = NSMutableAttributedString(string: "template".localized,
    ///                                          attributes: ...)
    /// let text = NSMutableAttributedString(
    ///     format: template,
    ///     args: NSMutableAttributedString(string: "Some arg", attributes: ...)
    /// )
    /// ````
    convenience init(format: NSAttributedString, args: NSAttributedString...) {
        let mutableNsAttributedString = NSMutableAttributedString(attributedString: format)
        
        args.forEach { attributedString in
            let range = NSString(string: mutableNsAttributedString.string).range(of: "%@")
            mutableNsAttributedString.replaceCharacters(in: range, with: attributedString)
        }
        
        self.init(attributedString: mutableNsAttributedString)
    }
    
    func appendWithNewline(_ attributedString: NSAttributedString) {
        if self.length > 0 {
            self.append(NSAttributedString(string: "\n"))
        }
        
        self.append(attributedString)
    }
}
