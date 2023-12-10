//
//  Logger+Extensions.swift
//  SwiftyGallery
//
//  Created by Leonardo de Oliveira on 08/12/23.
//

import OSLog

extension Logger {
    /// Using your bundle identifier is a great way to ensure a unique identifier.
    private static var subsystem = Bundle.main.bundleIdentifier!
    
    /// All logs related to network activity
    //static let network = Logger(subsystem: subsystem, category: "network")
}
