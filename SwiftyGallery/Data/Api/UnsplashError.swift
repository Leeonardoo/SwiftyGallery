//
//  NothingDecodable.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 07/12/23.
//

import Foundation

struct UnsplashError: ErrorMapper {
    
    var isEmpty: Bool {
        description.isEmpty
    }
    
    var description: String {
        get {
            errors?.joined(separator: "\n") ?? ""
        }
    }
    
    let errors: [String]?
}
