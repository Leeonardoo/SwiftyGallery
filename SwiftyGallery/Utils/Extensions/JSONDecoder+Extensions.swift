//
//  JSONDecoder+Extensions.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 09/12/23.
//

import Foundation

extension JSONDecoder {
    
    static let defaultDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        return decoder
    }()
}
