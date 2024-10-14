//
//  ErrorMapper.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 14/10/24.
//

import Foundation

protocol ErrorMapper : Decodable & CustomStringConvertible {
    var isEmpty: Bool {
        get
    }
}
