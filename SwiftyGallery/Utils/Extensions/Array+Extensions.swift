//
//  Array+Extensions.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 31/12/23.
//

import Foundation

extension Array {
    func unique<T: Equatable>(by selector: (Element) -> T) -> Array<Element> {
        return reduce(Array<Element>()){
            if let last = $0.last {
                return selector(last) == selector($1) ? $0 : $0 + [$1]
            } else {
                return [$1]
            }
        }
    }
}
