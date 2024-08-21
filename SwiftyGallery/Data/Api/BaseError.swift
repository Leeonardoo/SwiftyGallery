//
//  NothingDecodable.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 07/12/23.
//

import Foundation

struct BaseError: Decodable, CustomStringConvertible {
    
    var description: String {
        get {
            base
        }
    }
    
    let base: String
}
