//
//  String+Extensions.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 21/08/23.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, 
                                 tableName: nil,
                                 bundle: Bundle.main,
                                 value: "",
                                 comment: "")
    }
    
    func localized(_ comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    func localized(_ comment: String = "", with arguments: CVarArg...) -> String {
        return String.localizedStringWithFormat(self.localized(comment), arguments)
    }
}
